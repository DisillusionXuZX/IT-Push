//
//  XZXMainCell.m
//  IT Express
//
//  Created by xuzx on 16/4/7.
//  Copyright © 2016年 xuzx. All rights reserved.
//

#import "XZXMainCell.h"
#import "XZXMainModel.h"
#import <UIImageView+WebCache.h>

@interface XZXMainCell()
@property (weak, nonatomic) IBOutlet UIImageView *articleView;
@property (weak, nonatomic) IBOutlet UILabel *articleLabel;

@end

@implementation XZXMainCell

- (void)setModel:(XZXMainModel *)model{
    _model = model;
    self.articleLabel.text = model.articleName;
    if(model.articleImageURL == nil  || [model.articleImageURL isEqualToString:@""]){
        int num = arc4random_uniform(5);
        NSString *imageName = [@"photo-" stringByAppendingString:[NSString stringWithFormat:@"%d", num]];
        self.articleView.image = [UIImage imageNamed:imageName];
    }else{
        [self.articleView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:model.articleImageURL] placeholderImage:[UIImage imageNamed:@"navbar_logo~iPhone"] options:SDWebImageCacheMemoryOnly progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
