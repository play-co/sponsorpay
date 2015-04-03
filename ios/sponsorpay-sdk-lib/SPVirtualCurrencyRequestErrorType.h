//
//  SPVirtualCurrencyRequestErrorType.h
//  SponsorPaySDK
//
//  Created by tito on 15/07/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#ifndef SponsorPaySDK_SPVirtualCurrencyRequestErrorType_h
#define SponsorPaySDK_SPVirtualCurrencyRequestErrorType_h

typedef NS_ENUM(NSInteger, SPVirtualCurrencyRequestErrorType) {
    NO_ERROR,
    ERROR_NO_INTERNET_CONNECTION,
    ERROR_INVALID_RESPONSE,
    ERROR_INVALID_RESPONSE_SIGNATURE,
    SERVER_RETURNED_ERROR,
    ERROR_OTHER
};

#endif
