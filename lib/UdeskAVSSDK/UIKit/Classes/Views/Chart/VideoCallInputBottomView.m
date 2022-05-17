//
//  VideoCallInputBottomView.m
//  UdeskApp
//
//  Created by 陈历 on 2020/5/22.
//  Copyright © 2020 xushichen. All rights reserved.
//

#import "VideoCallInputBottomView.h"
#import "UdeskProjectHeader.h"

static NSString *const reuse_cell = @"UICollectionViewCell";

@interface VideoCallInputBottomView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation VideoCallInputBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.06];
        self.dataList = @[@(VideoCallInputBottomButtonTypeImage)];
        [self.collectionView reloadData];
    }
    return self;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(0, 0);
        CGFloat space = 10;
        
        flowLayout.minimumInteritemSpacing = space;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 16, 10, 16);
        flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuse_cell];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [self addSubview:_collectionView];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _collectionView;
}

- (void)setupViews{
    UIButton *image = [self createButton:@"udMessageImage" selectedImage:@"udMessageImage" tag:VideoCallInputBottomButtonTypeImage];
    image.left = 16;
    [self addSubview:image];
}

- (UIButton *)createButton:(NSString *)normalImage selectedImage:(NSString *)selectImage tag:(NSInteger)tag{
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 16, 48 , 48)];
    [button setImage:[UIImage udavs_imageNamed:normalImage] forState:UIControlStateNormal];
    [button setImage:[UIImage udavs_imageNamed:selectImage] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    button.layer.cornerRadius = 8.0;
    button.backgroundColor = [UIColor whiteColor];
    return button;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(40, 65);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse_cell forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    NSNumber *type = [self.dataList objectAtIndex:indexPath.row];
    [self configCell:cell type:type];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *type = [self.dataList objectAtIndex:indexPath.row];
    if (self.block) {
        self.block(@(type.intValue));
    }
}

- (void)configCell:(UICollectionViewCell *)cell type:(NSNumber *)type{
    UIImageView *iv = [cell viewWithTag:1000];
    if (!iv) {
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        iv.tag = 1000;
        [cell addSubview:iv];
    }
    UILabel *textLabel = [cell viewWithTag:1001];
    if (!textLabel) {
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 40, 25)];
        textLabel.font = UDAVS_FONT(12);
        textLabel.tag = 1001;
        textLabel.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:textLabel];
    }
    
    if (type.intValue == VideoCallInputBottomButtonTypeImage) {
        iv.image = [UIImage udavs_imageNamed:@"udMessageImage"];
        textLabel.text = @"图片";
    }
}

- (void)buttonPressed:(UIButton *)sender{
    if (self.block) {
        self.block(@(sender.tag));
    }
}

- (void)dealloc{
    NSLog(@"%@ dealloc p=%p", [self class], self);
}

@end
