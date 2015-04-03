//
//  SPOfferWallStatus.h
//  SponsorPaySDK
//
//  Created by tito on 07/08/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#ifndef SponsorPaySDK_SPOfferWallStatus_h
#define SponsorPaySDK_SPOfferWallStatus_h

/** These constants are used to refer to the different states an engagement can be in. */
typedef NS_ENUM(NSInteger, SPOfferWallStatus) {
    SPOfferWallStatusNetworkError = -1,
    SPOfferWallStatusNoOffer,
    SPOfferWallStatusFinishedByUser
};


#endif
