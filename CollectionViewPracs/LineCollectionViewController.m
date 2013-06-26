//
//  LineCollectionViewController.m
//  CollectionViewPracs
//
//  Created by Ha Minh Vuong on 6/26/13.
//  Copyright (c) 2013 Ha Minh Vuong. All rights reserved.
//

#import "LineCollectionViewController.h"

#import "Data.h"

static NSString *const identifier = @"CollectionViewCell";

@interface LineCollectionViewController ()

@end

@implementation LineCollectionViewController

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
	// Do any additional setup after loading the view.

    [self.collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
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

@end
