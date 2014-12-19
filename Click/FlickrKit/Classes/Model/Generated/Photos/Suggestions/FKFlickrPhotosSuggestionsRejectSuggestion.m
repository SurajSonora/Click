//
//  FKFlickrPhotosSuggestionsRejectSuggestion.m
//  FlickrKit
//
//  Generated by FKAPIBuilder on 19 Sep, 2014 at 10:49.
//  Copyright (c) 2013 DevedUp Ltd. All rights reserved. http://www.devedup.com
//
//  DO NOT MODIFY THIS FILE - IT IS MACHINE GENERATED


#import "FKFlickrPhotosSuggestionsRejectSuggestion.h" 

@implementation FKFlickrPhotosSuggestionsRejectSuggestion



- (BOOL) needsLogin {
    return YES;
}

- (BOOL) needsSigning {
    return YES;
}

- (FKPermission) requiredPerms {
    return 1;
}

- (NSString *) name {
    return @"flickr.photos.suggestions.rejectSuggestion";
}

- (BOOL) isValid:(NSError **)error {
    BOOL valid = YES;
	NSMutableString *errorDescription = [[NSMutableString alloc] initWithString:@"You are missing required params: "];
	if(!self.suggestion_id) {
		valid = NO;
		[errorDescription appendString:@"'suggestion_id', "];
	}

	if(error != NULL) {
		if(!valid) {	
			NSDictionary *userInfo = @{NSLocalizedDescriptionKey: errorDescription};
			*error = [NSError errorWithDomain:FKFlickrKitErrorDomain code:FKErrorInvalidArgs userInfo:userInfo];
		}
	}
    return valid;
}

- (NSDictionary *) args {
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
	if(self.suggestion_id) {
		[args setValue:self.suggestion_id forKey:@"suggestion_id"];
	}

    return [args copy];
}

- (NSString *) descriptionForError:(NSInteger)error {
    switch(error) {
		case FKFlickrPhotosSuggestionsRejectSuggestionError_SSLIsRequired:
			return @"SSL is required";
		case FKFlickrPhotosSuggestionsRejectSuggestionError_InvalidSignature:
			return @"Invalid signature";
		case FKFlickrPhotosSuggestionsRejectSuggestionError_MissingSignature:
			return @"Missing signature";
		case FKFlickrPhotosSuggestionsRejectSuggestionError_LoginFailedOrInvalidAuthToken:
			return @"Login failed / Invalid auth token";
		case FKFlickrPhotosSuggestionsRejectSuggestionError_UserNotLoggedInOrInsufficientPermissions:
			return @"User not logged in / Insufficient permissions";
		case FKFlickrPhotosSuggestionsRejectSuggestionError_InvalidAPIKey:
			return @"Invalid API Key";
		case FKFlickrPhotosSuggestionsRejectSuggestionError_ServiceCurrentlyUnavailable:
			return @"Service currently unavailable";
		case FKFlickrPhotosSuggestionsRejectSuggestionError_WriteOperationFailed:
			return @"Write operation failed";
		case FKFlickrPhotosSuggestionsRejectSuggestionError_FormatXXXNotFound:
			return @"Format \"xxx\" not found";
		case FKFlickrPhotosSuggestionsRejectSuggestionError_MethodXXXNotFound:
			return @"Method \"xxx\" not found";
		case FKFlickrPhotosSuggestionsRejectSuggestionError_InvalidSOAPEnvelope:
			return @"Invalid SOAP envelope";
		case FKFlickrPhotosSuggestionsRejectSuggestionError_InvalidXMLRPCMethodCall:
			return @"Invalid XML-RPC Method Call";
		case FKFlickrPhotosSuggestionsRejectSuggestionError_BadURLFound:
			return @"Bad URL found";
  
		default:
			return @"Unknown error code";
    }
}

@end
