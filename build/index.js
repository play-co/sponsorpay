var fs = require('fs');
var path = require('path');
var Promise = require('bluebird');
var mkdirp = require('mkdirp');
var fsExtra = require('fs.extra');
var rimraf = require('rimraf');

var readFileAsync = Promise.promisify(fs.readFile, fs);
var writeFileAsync = Promise.promisify(fs.writeFile, fs);

var copyFolderAsync = Promise.promisify(fsExtra.copyRecursive, fsExtra);
var rimrafAsync = Promise.promisify(rimraf, rimraf);


var XSL_KEYS_MARKER = '<!--*****SPONSORPAY_XSL_KEYS*****-->';
var XSL_TEMPLATES_MARKER = '<!--*****SPONSORPAY_XSL_TEMPLATES*****-->';
var XML_APPLICATION_MARKER = '<!--*****SPONSORPAY_PLUGINS_APPLICATION*****-->';
var XML_ACTIVITY_MARKER = '<!--*****SPONSORPAY_PLUGINS_ACTIVITY*****-->';
var XML_MANIFEST_MARKER = '<!--*****SPONSORPAY_PLUGINS_MANIFEST*****-->';

/**
 * SponsorPay.build#onBeforeBuild
 *
 * Creates the android/ios folder at build time by reading the manifest
 * for enabled plugins and building the correct files.
 *
 */
exports.onBeforeBuild = function (devkitAPI, app, config, cb) {

  // for each provider
  //  -  merge config.json
  //  -  merge manifest.xml files -- xmlActivity.xml, xmlApplication.xml, xmlManifest.xml 
  //  -  merge manifest.xsl files -- xslKeys.xsl, xslTemplates.xsl
  //  -  add matching pieces of adapters files -- adapters.config, adapters.info
  //  -  copy everything in files to the platform folder

  var err = null;

  var providers = [];
  var folder;
  // read manifest for which providers are enabled
  if (config.target === 'native-android') {
    if (!app.manifest.addons ||
        !app.manifest.addons.sponsorpay ||
        !app.manifest.addons.sponsorpay.android ||
        !app.manifest.addons.sponsorpay.android.providers) {
      logger.warn('{sponsorPay} No providers found -- looked in manifest.addons.sponsorpay.android.providers');
    } else {
      providers = app.manifest.addons.sponsorpay.android.providers;
    }
    folder = 'android';
  } else {
    if (!app.manifest.addons ||
        !app.manifest.addons.sponsorpay ||
        !app.manifest.addons.sponsorpay.ios ||
        !app.manifest.addons.sponsorpay.ios.providers) {
      logger.warn('{sponsorPay} No providers found -- looked in manifest.addons.sponsorpay.ios.providers');
    } else {
      providers = app.manifest.addons.sponsorpay.ios.providers;
    }
    folder = 'ios';
  }

  // always include sponsorpay
  providers.push('sponsorpay');

  // read provider config and copy any necessary files
  var infoPromises = [];
  var configPromises = [];
  var copyPaths = {};
  var xslKeyPromises = [];
  var xslTemplatePromises = [];
  var xmlApplicationPromises = [];
  var xmlActivityPromises = [];
  var xmlManifestPromises = [];
  for (var i = 0; i < providers.length; i++) {

    var provider = providers[i];
    logger.log("{sponsorPay} Adding provider", provider);
    var dirname = path.join(__dirname, 'providers', provider, folder);

    // read provider config.json
    var configFile = path.join(dirname, 'config.json');
    configPromises.push(
      readFileAsync(configFile, 'utf8').then(function (contents) {
        return JSON.parse(contents);
      })
    );

    // copy all the files in 'files'
    copyPaths[path.join(dirname, 'files')] = path.join(__dirname, '..', folder);

    if (config.target === 'native-android') {
      // read provider manifest.xsl changes
      var xslKeys = path.join(dirname, 'xslKeys.xsl');
      xslKeyPromises.push(
        readFileAsync(xslKeys, 'utf8')
      );
      var xslTemplate = path.join(dirname, 'xslTemplates.xsl');
      xslTemplatePromises.push(
        readFileAsync(xslTemplate, 'utf8')
      );

      // read provider manifest.xml changes
      var xmlApplication = path.join(dirname, 'xmlApplication.xml');
      xmlApplicationPromises.push(
        readFileAsync(xmlApplication, 'utf8')
      );
      var xmlManifest = path.join(dirname, 'xmlManifest.xml');
      xmlManifestPromises.push(
        readFileAsync(xmlManifest, 'utf8')
      );
      var xmlActivity = path.join(dirname, 'xmlActivity.xml');
      xmlActivityPromises.push(
        readFileAsync(xmlActivity, 'utf8')
      );
    }
  }


  // merge all the configs together
  var configPromise = processConfig(configPromises);

  // combine xsl
  var xslPromise, xmlPromise;
  if (config.target === 'native-android') {
    var baseXslPath = path.join(__dirname, folder, 'manifest.xsl');
    var xslPromise = processXsl(baseXslPath, xslKeyPromises, xslTemplatePromises);

    // combine xml
    var baseXmlPath = path.join(__dirname, folder, 'manifest.xml');
    var xmlPromise = processXml(
      baseXmlPath,
      xmlActivityPromises,
      xmlApplicationPromises,
      xmlManifestPromises
    );
  }

  // path to plugin platform folder (eg: sponsorpay/android)
  var platformPath = path.join(__dirname, '..', folder);

  // remove the target folder in the plugin and recreate with correct content
  rimrafAsync(platformPath).then(function () {
    mkdirp(platformPath);
  }).then(function () {
    mkdirp(path.join(platformPath, 'src'));
  }).then(function () {
    return Promise.all([
      // read plugin info file
      readFileAsync(path.join(__dirname, 'providers', 'info.json'), 'utf8'),

      // read adapters.info
      readFileAsync(path.join(__dirname, 'android', 'adapters.info'), 'utf8'),

      // read adapters.config
      readFileAsync(
        path.join(app.paths.src, 'adapters.config'),
        'utf8'
      )
    ]);
  }).spread(function (pluginInfo, adaptersInfo, adaptersConfig) {
    // remove all unnecessary items from adapters (sponsorpay fails otherwise)
    var finalAdaptersInfo = processAdaptersInfo(
      providers,
      pluginInfo,
      adaptersInfo
    );

    var finalAdaptersConfig = processAdaptersConfig(
      providers,
      pluginInfo,
      adaptersConfig
    );

    return Promise.all([
      // write adapters.config
      writeFileAsync(
        path.join(platformPath, 'src', 'adapters.config'),
        JSON.stringify(finalAdaptersConfig),
        {encoding: 'utf8'}
      ),

      // write adapters.info
      writeFileAsync(
        path.join(platformPath, 'src', 'adapters.info'),
        JSON.stringify(finalAdaptersInfo),
        {encoding: 'utf8'}
      )
    ]);
  }).then(function () {

    var copyPromises = [];
    var srcPaths = Object.keys(copyPaths);
    for (var i = 0; i < srcPaths.length; i++) {
      copyPromises.push(
        copyFolderAsync(
          srcPaths[i],
          copyPaths[srcPaths[i]]
        )
      );
    }

    return Promise.all([
      configPromise, xslPromise, xmlPromise, Promise.all(copyPromises)
    ]);
  }).spread(function (finalConfig, finalXsl, finalXml) {
      var writePromises = [
        // write config.json
        writeFileAsync(
          path.join(platformPath, 'config.json'),
          JSON.stringify(finalConfig),
          {encoding: 'utf8'}
        )
      ];

      if (config.target === 'native-android') {
        // write manifest.xml
        writePromises.push(
          writeFileAsync(
            path.join(platformPath, 'manifest.xml'),
            finalXml,
            {encoding: 'utf8'}
          )
        );

        // write manifest.xsl
        writePromises.push(
          writeFileAsync(
            path.join(platformPath, 'manifest.xsl'),
            finalXsl,
            {encoding: 'utf8'}
          )
        );
      }

      return Promise.all(writePromises);
  }).spread(function () {
    logger.log("{sponsorPay} Finished setting up providers");
    cb();
  });
}


/**
 * Accepts a list of promises with the content of config files
 * then merges them all together and returns the final config.
 */
function processConfig(configPromises) {
  return Promise.reduce(
    configPromises,
    function (baseConfig, providerConfig) {
      mergeConfig(baseConfig, providerConfig);
      return baseConfig;
    },
    {}
  );
}


/**
 * Accepts a path to the base xml file and lists of promises with the contents
 * of plugin xslKey and xslTemplate sections.
 * Reads the given baseXsl and injects the concatenated plugin content
 * into the baseXsl, returning the final xsl.
 */
function processXsl(baseXslPath, xslKeyPromises, xslTemplatePromises) {
  var xslKeyPromise = concatContent(xslKeyPromises);
  var xslTemplatePromise = concatContent(xslTemplatePromises);

  return Promise.all([
    readFileAsync(baseXslPath, 'utf8'),
    xslKeyPromise,
    xslTemplatePromise
  ]).spread(function (baseXsl, xslKeys, xslTemplates) {
    // inject templates
    baseXsl = injectContent(baseXsl, XSL_KEYS_MARKER, xslKeys);
    baseXsl = injectContent(baseXsl, XSL_TEMPLATES_MARKER, xslTemplates);

    return baseXsl;
  });
}

/**
 * Accepts a path to the base xml file and lists of promises with the contents
 * of plugin xmlApplication, xmlActivity, and xmlManifest files.
 * Reads the given baseXml and injects the concatenated plugin content
 * into the baseXml, returning the final xml.
 */
function processXml(baseXmlPath, xmlActivityPromises, xmlApplicationPromises, xmlManifestPromises) {
  var xmlActivityPromise = concatContent(xmlActivityPromises);
  var xmlApplicationPromise = concatContent(xmlApplicationPromises);
  var xmlManifestPromise = concatContent(xmlManifestPromises);

  return Promise.all([
    readFileAsync(baseXmlPath, 'utf8'),
    xmlActivityPromise,
    xmlApplicationPromise,
    xmlManifestPromise
  ]).spread(function (baseXml, xmlActivity, xmlApplication, xmlManifest) {
    // inject templates
    baseXml = injectContent(baseXml, XML_ACTIVITY_MARKER, xmlActivity);
    baseXml = injectContent(baseXml, XML_APPLICATION_MARKER, xmlApplication);
    baseXml = injectContent(baseXml, XML_MANIFEST_MARKER, xmlManifest);

    return baseXml;
  });
}

/**
 * Accepts a string, a marker, and content and returns the string
 * with the marker replaced with the content.
 */
function injectContent(content, marker, newContent) {
  var index = content.indexOf(marker);
  if (index > -1) {
    content = content.slice(0, index) +
      newContent +
      content.slice(index + marker.length);
  }
  return content;
}

/**
 * Accepts a list of promises that return some file content and
 * concatenates them all together, returning a promise with the
 * final, concatenated content.
 */
function concatContent(promises) {
  return Promise.reduce(
    promises,
    function (baseContent, providerContent) {
      baseContent += providerContent;
      return baseContent;
    },
    ''
  );
}

/**
 * Accepts the list of providers, the plugin info.json content and the
 * adapters.info file from the application and removes all the unused platform
 * blocks, returning the final object representing adapters.info.
 */
function processAdaptersInfo(providers, pluginInfoContent, adaptersInfoContent) {

  var pluginInfo = {};
  try {
    pluginInfo = JSON.parse(pluginInfoContent);
  } catch (e) {
    logger.error("{sponsorPay} FATAL: Failed to parse info.config from your sponsorpay module. Your module installation may be corrupted.", e.toString());
  }

  var adaptersInfo = {adapters: []};
  try {
    adaptersInfo = JSON.parse(adaptersInfoContent);
  } catch (e) {
    logger.error("{sponsorPay} FATAL: Failed to parse adapters.info from your application's src folder. Sponsorpay cannot be initialized.", e.toString());
  }

  var finalInfo = { adapters: [] };
  for (var i = 0; i < providers.length; i++) {
    var provider = providers[i];

    if (pluginInfo[provider]) {
      var identifier = pluginInfo[provider].adaptersInfo.identifier;
      for (var j = 0; j < adaptersInfo.adapters.length; j++) {
        var adapter = adaptersInfo.adapters[j];

        // check if block matches this provider
        if (adapter[identifier.key] === identifier.value) {
          finalInfo.adapters.push(adapter);
          break;
        }
      }
    } else if (provider === 'sponsorpay') {
      // ignore base sponsorpay provider
    } else {
      logger.warn("{sponsorPay} Could not find adapter info for " + provider);
    }
  }

  return finalInfo;
}

/**
 * Accepts the list of providers, the plugin info.json content and the
 * adapters.config file from the application and removes all the unused
 * platform blocks, returning the final object representing adapters.config.
 */
function processAdaptersConfig(providers, pluginInfoContent, adaptersConfigContent) {

  var pluginInfo = {};
  try {
    pluginInfo = JSON.parse(pluginInfoContent);
  } catch (e) {
    logger.error("{sponsorPay} FATAL: Failed to parse info.config from your sponsorpay module. Your module installation may be corrupted.", e.toString());
  }

  var adaptersConfig = {adapters: []};
  try {
    adaptersConfig = JSON.parse(adaptersConfigContent);
  } catch (e) {
    logger.error("{sponsorPay} FATAL: Failed to parse adapters.config from your application's src folder. Sponsorpay cannot be initialized.", e.toString());
  }

  var finalConfig = { adapters: [] };
  for (var i = 0; i < providers.length; i++) {
    var provider = providers[i];
    if (pluginInfo[provider]) {
      var identifier = pluginInfo[provider].adaptersConfig.identifier;
      for (var j = 0; j < adaptersConfig.adapters.length; j++) {
        var adapter = adaptersConfig.adapters[j];
        // check if block matches this provider
        if (adapter[identifier.key] === identifier.value) {
          finalConfig.adapters.push(adapter);
          break;
        }
      }
    }
  }

  return finalConfig;
}

/**
 * Merges config. Expects the newConfig form to match existing config form.
 * Does not do error checking - only use this when you have control of both
 * inputs.
 */
var mergeConfig = function (config, newConfig) {
  var keys = Object.keys(newConfig);
  for (var i = 0; i < keys.length; i++) {
    var key = keys[i];

    // if key already exists
    if (key in config) {
      // value is an array, merge array (assumes both are arrays)
      if (Array.isArray(config[key])) {
        for (var j = 0; j < newConfig[key].length; j++) {
          var val = newConfig[key][j];
          if (config[key].indexOf(val) === -1) {
            config[key].push(val);
          }
        }
      } else if (typeof config[key] === 'object') {
        // value is an object, recurse
        mergeConfig(config[key], newConfig[key]);
      } else {
        // warn about overwriting keys
        console.warn(
          "{sponsorPay} Warning - onBeforeBuild config overwrote existing key",
          key
        );
        config[key] = newConfig[key];
      }
    } else {
      config[key] = newConfig[key];
    }
  }
};

