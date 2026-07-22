#import <UIKit/UIKit.h>

@interface PXBaseTableViewController : UITableViewController
- (UITableViewCell *)switchCellTitle:(NSString *)title detail:(NSString *)detail key:(NSString *)key;
- (UITableViewCell *)disclosureCellTitle:(NSString *)title detail:(NSString *)detail;
- (BOOL)ru;
@end
