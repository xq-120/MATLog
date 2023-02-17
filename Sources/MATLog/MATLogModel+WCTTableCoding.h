//
//  MATLogModel+WCTTableCoding.h
//  MATLog
//
//  Created by xq on 2023/2/17.
//

#import "MATLogModel.h"
#import <WCDB/WCDB.h>

@interface MATLogModel (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(logID)
WCDB_PROPERTY(logTimestamp)
WCDB_PROPERTY(logContent)
WCDB_PROPERTY(logDetail)

@end
