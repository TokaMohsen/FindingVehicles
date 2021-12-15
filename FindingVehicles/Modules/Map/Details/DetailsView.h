//
//  DetailsView.h
//  FindingVehicles
//
//  Created by toka mohsen on 09/12/2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailsView : UIView

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property(nonatomic , assign) NSString *type;
@property(nonatomic , assign) NSString *status;

- (id)initWithVehicle:(NSString*)vehicleType  vehicleStatus:( NSString*)vehicleStatus;
@end

NS_ASSUME_NONNULL_END
