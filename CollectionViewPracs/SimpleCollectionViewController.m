//
//  SimpleCollectionViewController.m
//  CollectionViewPracs
//
//  Created by Ha Minh Vuong on 6/23/13.
//  Copyright (c) 2013 Ha Minh Vuong. All rights reserved.
//

#import "SimpleCollectionViewController.h"
#import "Data.h"
#import "SimpleCollectionReusableView.h"

static NSString *const identifier = @"CollectionViewCell";
static NSString *const kindIdentifier = @"KindReuse";

@interface SimpleCollectionViewController ()

@end

@implementation SimpleCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    UICollectionViewFlowLayout* layout = (id)self.collectionView.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    layout.headerReferenceSize = CGSizeMake(0, 5); // only height matters
    layout.footerReferenceSize = CGSizeMake(0, 5);
    layout.itemSize = CGSizeMake(60,60);

//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    [self.collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
    [self.collectionView registerClass:[SimpleCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kindIdentifier];
    [self.collectionView registerClass:[SimpleCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kindIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[Data data] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[Data data][section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identifier = @"CollectionViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    label.text = [Data data][indexPath.section][indexPath.row];
    
    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    SimpleCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kindIdentifier forIndexPath:indexPath];
    if (kind == UICollectionElementKindSectionHeader) {
        view.backgroundColor = [UIColor lightGrayColor];
    } else {
        view.backgroundColor = [UIColor darkGrayColor];
    }

    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [Data data][indexPath.section][indexPath.row];
    NSLog(@"%@", str);
}

@end
