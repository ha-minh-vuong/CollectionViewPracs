//
//  LineLayout.m
//  CollectionViewPracs
//
//  Created by Ha Minh Vuong on 6/26/13.
//  Copyright (c) 2013 Ha Minh Vuong. All rights reserved.
//

#import "LineLayout.h"


#define kItemSize 50
#define kSectionInset 170
#define kDistance 190
#define kZoomScale 0.5

@implementation LineLayout

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
    self.itemSize = CGSizeMake(kItemSize, kItemSize);
    self.sectionInset = UIEdgeInsetsMake(kSectionInset, 0.0, kSectionInset, 0.0);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect = CGRectZero;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes *attribute in array) {
        if (CGRectIntersectsRect(attribute.frame, rect)) {
            CGFloat dist = CGRectGetMidX(visibleRect) - attribute.center.x;
            CGFloat normalizedDist = dist / kDistance;            
            if (ABS(dist) < kDistance) {
                CGFloat zoom = 1 + kZoomScale*(1 - ABS(normalizedDist));
                attribute.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attribute.zIndex = 1;
            }
        }
    }
    
    return array;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end

// WARNING: just run well on 3.5 inches simulator.
// TODO: fix it!
