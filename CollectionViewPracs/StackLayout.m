//
//  StackLayout.m
//  CollectionViewPracs
//
//  Created by Ha Minh Vuong on 6/24/13.
//  Copyright (c) 2013 Ha Minh Vuong. All rights reserved.
//

#import "StackLayout.h"
#import <QuartzCore/QuartzCore.h>

#define kRotationStride 3
#define kRotationCount 45

static NSString * const StackLayoutCellKind = @"StackCell";

@interface StackLayout()

@property (nonatomic, strong) NSDictionary *layout;

@property (nonatomic, strong) NSArray *rotations;

@property (nonatomic) UIEdgeInsets sectionInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;

@end

@implementation StackLayout

- (id)init
{
    self = [super init];
    if (self) {
        [self setupLayout];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupLayout];
    }
    return self;
}

- (void)setupLayout
{
    self.sectionInsets = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f);   // here, section == item == cell.
    self.itemSize = CGSizeMake(125.0f, 125.0f);
    self.interItemSpacingY = 20.0f;
    self.numberOfColumns = 2;
    
    // collectionView.width = left + n * frame.width + (n-1) * spacing + right
    // Some info is redundant.
    
    NSMutableArray *rotations = [NSMutableArray arrayWithCapacity:kRotationCount];
    for (NSInteger i = 0; i < kRotationCount; i++) {
        CATransform3D transform = [self randomTransform3DMakeRotation];
        [rotations addObject:[NSValue valueWithCATransform3D:transform]];
    }
    self.rotations = rotations;
}

- (CATransform3D)randomTransform3DMakeRotation
{
    #define ARC4RANDOM_MAX 0x100000000
    CGFloat random = ((CGFloat)(arc4random() % ARC4RANDOM_MAX) * (30 - 0)) + 0;
    CGFloat angle = M_PI/180 * random;
    return CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0);
}

- (void)prepareLayout
{    
    NSMutableDictionary *layout = [[NSMutableDictionary alloc] init];
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = nil;
    
    for (NSInteger sect = 0; sect < numberOfSections; sect++) {
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:sect];
        for (NSInteger item = 0; item < numberOfItemsInSection; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:sect];
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attribute.frame = [self frameForCellAtIndexPath:indexPath];
            attribute.transform3D = [self transformForCellAtIndex:indexPath];
            layout[indexPath] = attribute;
        }
    }
    self.layout = layout;
}

- (CGRect)frameForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.section / self.numberOfColumns;
    NSInteger column = indexPath.section % self.numberOfColumns;
    
    CGFloat spacingX = self.collectionView.bounds.size.width - self.sectionInsets.left - self.sectionInsets.right - (self.numberOfColumns * self.itemSize.width);
    
    if (self.numberOfColumns > 1) {
        spacingX = spacingX / (self.numberOfColumns - 1);
    }
    
    CGFloat originX = floorf(self.sectionInsets.left + (self.itemSize.width + spacingX) * column);
    CGFloat originY = floor(self.sectionInsets.top + (self.itemSize.height + self.interItemSpacingY) * row);
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

- (CATransform3D)transformForCellAtIndex:(NSIndexPath *)indexPath
{
    
    NSInteger offset = (indexPath.section * kRotationStride + indexPath.item);
    return [self.rotations[offset % kRotationCount] CATransform3DValue];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [[NSMutableArray alloc] initWithCapacity:self.layout.count];
    [self.layout enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [attributes addObject:attribute];
        }
    }];
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layout[StackLayoutCellKind][indexPath];
}

- (CGSize)collectionViewContentSize
{
    NSInteger rowCount = [self.collectionView numberOfSections] / self.numberOfColumns;

    if ([self.collectionView numberOfSections] % self.numberOfColumns) {
        rowCount++;
    }
    
    CGFloat height = self.sectionInsets.top +
    rowCount * self.itemSize.height + (rowCount - 1) * self.interItemSpacingY +
    self.sectionInsets.bottom;

    return CGSizeMake(self.collectionView.bounds.size.width, height);
}

@end

// WARNING: This class is *very* slow.
// TODO: Make it faster.
