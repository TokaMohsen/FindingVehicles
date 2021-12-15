//
//  DetailsViewController.m
//  FindingVehicles
//
//  Created by toka mohsen on 09/12/2021.
//

#import "DetailsView.h"

@interface DetailsView ()

@end

@implementation DetailsView

- (id)initWithVehicle:(NSString*) vehicleType  vehicleStatus:( NSString*)vehicleStatus{
    if ((self = [super init])) {
        self.type = vehicleType;
        self.status = vehicleStatus;
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self=[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]objectAtIndex:0];
        
        frame.origin.x=0;
        frame.origin.y=0;
        self.frame=frame;
       
    }
    return self;
}

-(instancetype)initializeSubviews {
    id view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    return view;
}

- (void)setup
{
    self.contentView.frame = self.bounds;
    [self.contentView setAutoresizingMask: UIViewAutoresizingFlexibleWidth |
     UIViewAutoresizingFlexibleHeight];
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
    self.typeLabel.text = self.type;
    self.statusLabel.text = self.status;
    [self addSubview:self.contentView];
}
@end
