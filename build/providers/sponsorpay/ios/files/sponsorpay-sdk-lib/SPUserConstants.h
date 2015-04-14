//
//  SPUserConstants.h
//  SponsorPaySDK
//
//  Created by Piotr  on 24/07/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

static NSInteger const SPEntryIgnore = NSNotFound;
static double const SPGeoLocationValueNotFound = (double)SPEntryIgnore;

///-------------------------
/// Basic data
///-------------------------

typedef NS_ENUM(NSInteger, SPUserGender) {
    SPUserGenderUndefined = -1,
    SPUserGenderMale,
    SPUserGenderFemale,
    SPUserGenderOther
};

typedef NS_ENUM(NSInteger, SPUserSexualOrientation) {
    SPUserSexualOrientationUndefined = -1,
    SPUserSexualOrientationStraight,
    SPUserSexualOrientationBisexual,
    SPUserSexualOrientationGay,
    SPUserSexualOrientationUnknown
};

typedef NS_ENUM(NSInteger, SPUserEthnicity) {
    SPUserEthnicityUndefined = -1,
    SPUserEthnicityAsian,
    SPUserEthnicityBlack,
    SPUserEthnicityHispanic,
    SPUserEthnicityIndian,
    SPUserEthnicityMiddleEastern,
    SPUserEthnicityNativeAmerican,
    SPUserEthnicityPacificIslander,
    SPUserEthnicityWhite,
    SPUserEthnicityOther
};

typedef NS_ENUM(NSInteger, SPUserMaritalStatus) {
    SPUserMaritalStatusUndefined = -1,
    SPUserMartialStatusSingle,
    SPUserMartialStatusRelationship,
    SPUserMartialStatusMarried,
    SPUserMartialStatusDivorced,
    SPUserMartialStatusEngaged
};

typedef NS_ENUM(NSInteger, SPUserEducation) {
    SPUserEducationUndefined = -1,
    SPUserEducationOther,
    SPUserEducationNone,
    SPUserEducationHighSchool,
    SPUserEducationInCollege,
    SPUserEducationSomeCollege,
    SPUserEducationAssociates,
    SPUserEducationBachelors,
    SPUserEducationMasters,
    SPUserEducationDoctorate
};

///-------------------------
/// Extra
///-------------------------

typedef NS_ENUM(NSInteger, SPUserConnectionType) {
    SPUserConnectionTypeUndefined = -1,
    SPUserConnectionTypeWiFi,
    SPUserConnectionType3G,
    SPUserConnectionTypeLTE,
    SPUserConnectionTypeEdge
};

typedef NS_ENUM(NSInteger, SPUserDevice) {
    SPUserDeviceUndefined = -1,
    SPUserDeviceIPhone,
    SPUserDeviceIPad,
    SPUserDeviceIPod
};

// MARK: Mapping keys

static NSString *const SPUserDateFormat = @"yyyy/MM/dd";

static NSString *const SPUserAgeKey = @"age";
static NSString *const SPUserBirthdateKey = @"birthdate";
static NSString *const SPUserGenderKey = @"gender";
static NSString *const SPUserSexualOrientationKey = @"sexual_orientation";
static NSString *const SPUserEthnicityKey = @"ethnicity";
static NSString *const SPUserLocationLongitude = @"longt";
static NSString *const SPUserLocationLatitude = @"lat";
static NSString *const SPUserMaritalStatusKey = @"marital_status";
static NSString *const SPUserAnnualHouseholdIncomeKey = @"annual_household_income";
static NSString *const SPUserEducationKey = @"education";
static NSString *const SPUserZipCodeKey = @"zipcode";
static NSString *const SPUserInterestsKey = @"interests";
static NSString *const SPUserNumberOfChildrenKey = @"children";

static NSString *const SPUserIapKey = @"iap";
static NSString *const SPUserIapAmountKey = @"iap_amount";
static NSString *const SPUserNumberOfSessionsKey = @"number_of_sessions";
static NSString *const SPUserPsTimeKey = @"ps_time";
static NSString *const SPUserLastSessionKey = @"last_session";
static NSString *const SPUserConnectionTypeKey = @"connection";
static NSString *const SPUserDeviceKey = @"device";
static NSString *const SPUserVersionKey = @"version";

// MARK: Mapping arrays

static NSString *const SPUserMappingGender[4] = {
    @"male",
    @"female",
    @"other",
    NULL
};

static NSString *const SPUserMappingSexualOrientation[5] = {
    @"straight",
    @"bisexual",
    @"gay",
    @"unknown",
    NULL
};

static NSString *const SPUserMappingEthnicity[10] = {
    @"asian",
    @"black",
    @"hispanic",
    @"indian",
    @"middle eastern",
    @"native american",
    @"pacific islander",
    @"white",
    @"other",
    NULL
};

static NSString *const SPUserMappingMaritalStatus[6] = {
    @"single",
    @"relationship",
    @"married",
    @"divorced",
    @"engaged",
    NULL
};

static NSString *const SPUserMappingEducation[10] = {
    @"other",
    @"none",
    @"high school",
    @"in college",
    @"some college",
    @"associates",
    @"bachelors",
    @"masters",
    @"doctorate",
    NULL
};

static NSString *const SPUserMappingDevice[4] = {
    @"iPhone",
    @"iPad",
    @"iPod",
    NULL
};

static NSString *const SPUserMappingConnectionType[5] = {
    @"wifi",
    @"3g",
    @"lte",
    @"edge",
    NULL
};
