//
//  ViewController.m
//  GoogleMapsController
//
//  Created by Mrugrajsinh Vansadia on 10/06/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import "ViewController.h"
#import "MVPlaceSearchTextField.h"
#import <GoogleMaps/GoogleMaps.h>
#import "SWRevealViewController.h"
#import "homeViewController.h"
#import "SWRevealViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "SVProgressHUD.h"
#import "AppSinglton.h"
#import "AddPlaceCell.h"
#import "AppUtils.h"
#import "TollListCell.h"
#import "TollInfoTableCell.h"
#import "TollInfoUpperCell.h"
#import "TollInfoBottomCell.h"
#import "TollInfoTableInnerCell.h"
#import "NearByListController.h"
#import <MapKit/MapKit.h>
#import "PaymentDetailsController.h"

@interface ViewController ()<PlaceSearchTextFieldDelegate,UITextFieldDelegate,GMSMapViewDelegate>{
    NSArray *vehicalArr;
    NSString *selectedVehicleId;
    int addedPlaceCount;
    NSMutableArray *addedPlaceArr;
    NSArray *tollListArray;
    NSArray *paidtollListArray;
    NSDictionary *tollDetailInfo;
    BOOL isSource;
    BOOL isViaSelection;
    BOOL isTollExtraDetailsShown;
    int tollInfoCellcount;
    NSString *totalamount;
    NSString *paysource;
    NSString *paydestination
    ;
    NSMutableArray *checkedtollListArray;
    int checkedamount;
}
@property (weak, nonatomic) IBOutlet MVPlaceSearchTextField *txtDestinationCity;
@property (weak, nonatomic) IBOutlet MVPlaceSearchTextField *txtSourceCity;
@property (weak, nonatomic) IBOutlet UIView *addPlaceView;
@property (weak, nonatomic) IBOutlet UIView *addVehicleView;
@property (weak, nonatomic) IBOutlet UILabel *lblVehicle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightAddPlaceView;
@property (weak, nonatomic) IBOutlet MVPlaceSearchTextField *txdAddPlace;
@property (weak, nonatomic) IBOutlet UITableView *tblViewVehicles;
@property (weak, nonatomic) IBOutlet MVPlaceSearchTextField *txtFldVehicles;
@property (weak, nonatomic) IBOutlet MVPlaceSearchTextField *txtFldPlaceSearch;
@property (weak, nonatomic) IBOutlet UITableView *tblViewAddRemovePlace;
@property (weak, nonatomic) IBOutlet UIView *viewTollInfoTable;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalTime;
@property (weak, nonatomic) IBOutlet UILabel *lblVehicleName;
@property (weak, nonatomic) IBOutlet UITableView *tblTollList;
//@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) MKPolyline *routeLine; //your line
@property (nonatomic, retain) MKPolylineView *routeLineView; //overlay view
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *secondview;
@property (weak, nonatomic) IBOutlet MKMapView *mapsizeview;
@property (weak, nonatomic) IBOutlet UIView *mapcontainer;

@property (weak, nonatomic) IBOutlet UIView *viewTollDetailsInfo;
@property (weak, nonatomic) IBOutlet UITableView *tblViewTollDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleofView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightEnrouteViewSelection;
@property (weak, nonatomic) IBOutlet UIView *viewEnrouteSelectionContainer;
@property (weak, nonatomic) IBOutlet UIView *nearByOptions;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapcontainertopmargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapcontainerheight;

@property CLLocationCoordinate2D sourceCoord;
@property CLLocationCoordinate2D destinitionCoord;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setPreferenceForView];
    tollInfoCellcount = 0;
    tollDetailInfo = [[NSDictionary alloc] init];
    SWRevealViewController *revealViewController = self.revealViewController;
    vehicalArr = [[AppSinglton sharedManager] getVehiclesType];
     self.navigationController.navigationBar.hidden=YES;
    if ( revealViewController )
    {
        // [self.sidebarButton setTarget: self.revealViewController];
        //[self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    
    [self.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];

    [self setDefaultPref:_txtSourceCity];
    [self setDefaultPref:_txtDestinationCity];
    [self setDefaultPref:_txdAddPlace];
    
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    _txtSourceCity.leftView = paddingView;
    _txtSourceCity.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    _txtDestinationCity.leftView = paddingView1;
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    _txtDestinationCity.rightView = paddingView2;
    _txtDestinationCity.leftViewMode = UITextFieldViewModeAlways;
    
    _lblVehicle.text = @"Car/Jeep/Van";
    _txtFldVehicles.text =@"Car/Jeep/Van";
    selectedVehicleId = @"V0001";
    addedPlaceCount = 0;
    checkedamount =0;
    addedPlaceArr = [[NSMutableArray alloc] init];
    checkedtollListArray = [NSMutableArray arrayWithCapacity: 20];
    for (NSUInteger i = 0; i < 20; i++) {
        [checkedtollListArray addObject:[NSNull null]];
    }
    
    tollListArray = [[NSArray alloc] init];
    paidtollListArray = [[NSArray alloc] init];
     _heightAddPlaceView.constant = 150;
    _mapView.delegate = self;
    
    
    
}

-(void)setPreferenceForView {
    if(![_mapType isEqualToString:@"Enroute"]){
        _lblTitleofView.text = @"Toll Plaza(s) within 100km";
        _heightEnrouteViewSelection.constant = 1;
        _viewEnrouteSelectionContainer.hidden = YES;
        
                CGRect newFrame = CGRectMake( 0, 95, self.mapsizeview.frame.size.width, self.mapsizeview.frame.size.height
                                             );
        
        _mapcontainertopmargin.constant = 0;
        _mapcontainerheight.constant = 527;
        
       // _mapcontainer.layoutIfNeeded;
                //self.mapcontainer.frame = newFrame;
                //self.mapView.frame = newFrame;
                // _mapcontainer.frame = _mapsizeview.bounds;
       
       
     //   self.mapcontainer.bounds.origin = self.mapsizeview.bounds.origin;
//        NSLayoutConstraint *bottom1 =[NSLayoutConstraint
//                                      constraintWithItem:_mapcontainer
//                                      attribute:NSLayoutAttributeHeight
//                                      relatedBy:NSLayoutRelationEqual
//                                      toItem:_mapcontainer
//                                      attribute:NSLayoutAttributeHeight
//                                      multiplier:0.0f
//                                      constant:527.0f];
//        
//        NSLayoutConstraint *bottom2 =[NSLayoutConstraint
//                                      constraintWithItem:_mapView
//                                      attribute:NSLayoutAttributeHeight
//                                      relatedBy:NSLayoutRelationEqual
//                                      toItem:_mapView
//                                      attribute:NSLayoutAttributeHeight
//                                      multiplier:0.0f
//                                      constant:527.0f
//                                      ];
//
//       
//        
//        [_mapcontainer addConstraint:bottom1];
//
//         [_mapView addConstraint:bottom2];
        
        [self fetchNearByTolls];
        
//        NSLayoutConstraint *bottom =[NSLayoutConstraint
//                                     constraintWithItem:_mapView
//                                     attribute:NSLayoutAttributeHeight
//                                     relatedBy:NSLayoutRelationEqual
//                                     toItem:_mapsizeview
//                                     attribute:NSLayoutAttributeHeight
//                                     multiplier:1.0f
//                                     constant:0.f];
//        [_mapView addConstraint:bottom];
//        
        NSLayoutConstraint *top1 =[NSLayoutConstraint
                                      constraintWithItem:_mapcontainer
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:_secondview
                                      attribute:NSLayoutAttributeBottom
                                      multiplier:1.0f
                                      constant:0.f];
        
        
      //  [_mapcontainer addConstraint:bottom1];

       
       // _mapView.frame.size= _mapsizeview.bounds.size;
        
        
        
        
    }else{
        
        float currentLatitude = [[[AppSinglton sharedManager] getLatitude] floatValue];
        float currentLongitude = [[[AppSinglton sharedManager] getLoongitude] floatValue];
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLatitude
                                                                longitude:currentLongitude
                                                                     zoom:7];
        [_mapView setCamera:camera];
        _mapView.myLocationEnabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    //Optional Properties
    [self setTxtPref:_txtSourceCity];
    [self setTxtPref:_txtDestinationCity];
    [self setTxtPref:_txdAddPlace];
    
}

-(void)setDefaultPref:(MVPlaceSearchTextField*)txtfld{
    txtfld.placeSearchDelegate                 = self;
    txtfld.strApiKey                           = @"AIzaSyCZRk-lK0_G1wBOphfHYSIcCiKZ5n48Y0w";
    
    txtfld.superViewOfList                     = self.view;  // View, on which Autocompletion list should be appeared.
    txtfld.autoCompleteShouldHideOnSelection   = YES;
    txtfld.maximumNumberOfAutoCompleteRows     = 5;
}

-(void)setTxtPref: (MVPlaceSearchTextField*)txtfld{
    txtfld.autoCompleteRegularFontName =  @"HelveticaNeue-Bold";
    txtfld.autoCompleteBoldFontName = @"HelveticaNeue";
    txtfld.autoCompleteTableCornerRadius=0.0;
    txtfld.autoCompleteRowHeight=35;
    txtfld.autoCompleteTableCellTextColor=[UIColor colorWithWhite:0.131 alpha:1.000];
    txtfld.autoCompleteFontSize=14;
    txtfld.autoCompleteTableBorderWidth=1.0;
    txtfld.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=YES;
    txtfld.autoCompleteShouldHideOnSelection=YES;
    txtfld.autoCompleteShouldHideClosingKeyboard=YES;
    txtfld.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
    txtfld.autoCompleteTableFrame = CGRectMake((self.view.frame.size.width-txtfld.frame.size.width)*0.5, txtfld.frame.size.height+100.0, txtfld.frame.size.width, 200.0);
}

#pragma mark - Place search Textfield Delegates

-(void)placeSearch:(MVPlaceSearchTextField*)textField ResponseForSelectedPlace:(GMSPlace*)responseDict{
    [self.view endEditing:YES];
    NSLog(@"SELECTED ADDRESS :%@",responseDict);
    //responseDict.coordinate
    if(isSource && !isViaSelection){
        _sourceCoord = responseDict.coordinate;
        
    }else if(!isSource && !isViaSelection){
        _destinitionCoord = responseDict.coordinate;
    }
}
-(void)placeSearchWillShowResult:(MVPlaceSearchTextField*)textField{
    if(textField == _txtSourceCity){
        isViaSelection = NO;
        isSource = YES;
    }
    else if(textField == _txtDestinationCity){
        isViaSelection = NO;
        isSource = NO;
    }
    else{
        isViaSelection = YES;
    }
    
}
-(void)placeSearchWillHideResult:(MVPlaceSearchTextField*)textField{
    
}
-(void)placeSearch:(MVPlaceSearchTextField*)textField ResultCell:(UITableViewCell*)cell withPlaceObject:(PlaceObject*)placeObject atIndex:(NSInteger)index{
    if(index%2==0){
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
}
- (IBAction)BackTaped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addPlaceTapped:(id)sender {
    if(![_txtFldPlaceSearch.text length]){
        return;
    }
    [addedPlaceArr addObject:_txtFldPlaceSearch.text];
    CGRect frame =_addPlaceView.frame;
    if(frame.size.height<=[AppUtils deviceHeight]-70)
        frame.size.height = frame.size.height + 70;
    _addPlaceView.frame = frame;
    _heightAddPlaceView.constant = frame.size.height;
    _tblViewAddRemovePlace .hidden = NO;
    [_tblViewAddRemovePlace reloadData];
    _txtFldPlaceSearch.text = @"";
    
}
- (IBAction)searchOnPlaceTapped:(id)sender {
    _addPlaceView.hidden = YES;
    [self searchEnroute];
}
- (IBAction)hideAddPlace:(id)sender {
    _addPlaceView.hidden = YES;
}

- (IBAction)editVehicleTapped:(id)sender {
    _addVehicleView.hidden = NO;
    _tblViewVehicles.hidden = YES;
    
}

- (IBAction)addMoreDestinitionTapped:(id)sender {
    _addPlaceView.hidden = NO;
    _tblViewAddRemovePlace.hidden = YES;
}
- (IBAction)hideVehicelsView:(id)sender {
    _addVehicleView.hidden = YES;
}
- (IBAction)searchOnVehicleTapped:(id)sender {
    _addVehicleView.hidden = YES;
    [self searchEnroute];
}

- (IBAction)hideTollListView:(id)sender {
    [_viewTollInfoTable setHidden:YES];
}
- (IBAction)searchOnFieldTapped:(id)sender {
    [self searchEnroute];
}
- (IBAction)hideTollDetailsTapped:(id)sender {
    _viewTollDetailsInfo.hidden = YES;
}

-(void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message andAction:(BOOL)actionNeeded {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             if(actionNeeded){
                             }
                         }];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - TableView datasource and delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _tblViewVehicles){
         return 30;
    }else if(tableView == _tblViewAddRemovePlace){
        return 70;
    }else if(tableView == _tblTollList){
        return 42;
    }else if(tableView == _tblViewTollDetails){
        if(indexPath.row ==0){
            return 270;
        }
        if(indexPath.row ==1){
           return ([[tollDetailInfo objectForKey:@"VehicleRates"] count]*70)+100;
        }
        else
            return 270;
    }else{
        return 70;
    }
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(tableView == _tblViewVehicles){
        return vehicalArr.count;
    }else if(tableView == _tblViewAddRemovePlace){
        return addedPlaceArr.count;
    }else if(tableView == _tblTollList){
        return tollListArray.count;
    }else if(tableView == _tblViewTollDetails){
        return tollInfoCellcount;
    }else{
        return [[tollDetailInfo objectForKey:@"VehicleRates"] count];
    }

}


- (IBAction)payPressed:(id)sender {
    
    UIStoryboard* mainStoryBoard;
    mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    
    PaymentDetailsController* pd = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PaymentDetailsController"];
    
//    for (NSUInteger i = 0; i < [checkedtollListArray count]; i++) {
//        if([checkedtollListArray objectAtIndex:i] == [NSNull null])
//        {
//            [checkedtollListArray removeObjectAtIndex:i];
//        }
//    }
    
    NSPredicate *pred = [NSPredicate predicateWithBlock:^BOOL(id str, NSDictionary *unused) {
        return ![str isEqual:[NSNull null]];
    }];
    
    NSArray *finalcheckedarray = [checkedtollListArray filteredArrayUsingPredicate:pred];
    
    NSLog(@"Checked Toll Array : %@",finalcheckedarray);
    
    if([finalcheckedarray count] >0)
    {
        pd.tolllist = finalcheckedarray;
        pd.totalamount1 = [@(checkedamount) stringValue];
        
    }
    else
    {
        pd.tolllist = paidtollListArray;
        pd.totalamount1 = totalamount;
    }
    
    pd.psource = paysource;
    pd.pdestination = paydestination;
    
    [self.navigationController pushViewController:pd animated:YES];
   // [self.navigationController popViewControllerAnimated:YES];

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == _tblViewVehicles){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationListCell"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NotificationListCell"];
        }
        
        cell.textLabel.text = [[vehicalArr objectAtIndex:indexPath.row] objectForKey:@"VehicleName"];
        
        return cell;
    }else if(tableView == _tblViewAddRemovePlace){
        AddPlaceCell *cell = (AddPlaceCell*)[tableView dequeueReusableCellWithIdentifier:@"AddPlaceCell"];
        if (cell == nil)
        {
            cell = [[AddPlaceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddPlaceCell"];
        }
        
        cell.placeLbl.text = [addedPlaceArr objectAtIndex:indexPath.row];
        cell.removePlaceBtn.tag = indexPath.row;
        [cell.removePlaceBtn addTarget:self action:@selector(removeAddedPlace:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else  if(tableView == _tblTollList){
        //TollListCell.h
        TollListCell *cell = (TollListCell*)[tableView dequeueReusableCellWithIdentifier:@"TollListCell"];
        if (cell == nil)
        {
            cell = [[TollListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TollListCell"];
        }
        
        cell.lblTollName.text = [NSString stringWithFormat:@"%@",[[tollListArray objectAtIndex:indexPath.row] objectForKey:@"TollName"]];
        cell.lblTollPrice.text = [NSString stringWithFormat:@"%@",[[tollListArray objectAtIndex:indexPath.row] objectForKey:@"TollRate"]];
        
//        if(tollListArray.count == indexPath.row + 1)
//        {
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            btn.frame = CGRectMake(cell.contentView.frame.size.width/2,10,100,20);
//            [btn setTitle:@"Pay" forState:UIControlStateNormal];
//            [btn addTarget:self action:@selector(payPressed:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.contentView addSubview:btn];
//        }
        
        
        return cell;
    }
    else if(tableView == _tblViewTollDetails){
        if(indexPath.row == 0){
            //TollListCell.h
            TollInfoUpperCell *cell = (TollInfoUpperCell*)[tableView dequeueReusableCellWithIdentifier:@"TollInfoUpperCell"];
            if (cell == nil)
            {
                cell = [[TollInfoUpperCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TollInfoUpperCell"];
            }
            [cell updateDataWithInfo:tollDetailInfo];
            return cell;
        }
        if(indexPath.row == 1){
            //TollListCell.h
            TollInfoTableCell *cell = (TollInfoTableCell*)[tableView dequeueReusableCellWithIdentifier:@"TollInfoTableCell"];
            if (cell == nil)
            {
                cell = [[TollInfoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TollInfoTableCell"];
            }
            [cell.btnMoreDetails addTarget:self action:@selector(showMoreDetailsforToll) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else{
            //TollListCell.h
            TollInfoBottomCell *cell = (TollInfoBottomCell*)[tableView dequeueReusableCellWithIdentifier:@"TollInfoBottomCell"];
            if (cell == nil)
            {
                cell = [[TollInfoBottomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TollInfoBottomCell"];
            }
            [cell updateDataWithInfo:tollDetailInfo];
            return cell;
        }
    }else{
        //TollListCell.h
        TollInfoTableInnerCell *cell = (TollInfoTableInnerCell*)[tableView dequeueReusableCellWithIdentifier:@"TollInfoTableInnerCell"];
        if (cell == nil)
        {
            cell = [[TollInfoTableInnerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TollInfoTableInnerCell"];
        }
        [cell updateDataWithInfo:[[tollDetailInfo objectForKey:@"VehicleRates"] objectAtIndex:indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _tblTollList.frame.size.width, 60)];
    if(tableView == _tblTollList){
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                btn.frame = CGRectMake(footerView.frame.size.width/4, 40, footerView.frame.size.width/2, 50);
        btn.backgroundColor = [UIColor blueColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn setTitle:@"Pay" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(payPressed:) forControlEvents:UIControlEventTouchUpInside];
        
       
       
   
        [footerView addSubview:btn];
        footerView.center = _tblTollList.center;
    }
    return footerView;
    
}

//Ramneek Sharma
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(tableView == _tblViewVehicles){
        [self.view endEditing:YES];
        _tblViewVehicles.hidden = YES;
        _txtFldVehicles.text = [[vehicalArr objectAtIndex:indexPath.row] objectForKey:@"VehicleName"];
        _lblVehicle.text = [[vehicalArr objectAtIndex:indexPath.row] objectForKey:@"VehicleName"];
        selectedVehicleId =[NSString stringWithFormat:@"%@", [[vehicalArr objectAtIndex:indexPath.row] objectForKey:@"VehicleCode"]];
    }
    
    else if(tableView == _tblTollList)
    {
    //manual selection of tolls to pay for
        
        TollListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if(cell.checkbutton.selected)
        
        {
           cell.checkbutton.selected = !cell.checkbutton.selected;
            
            NSLog(@"Toll %@ unselected",cell.lblTollName.text);
            
             [checkedtollListArray  replaceObjectAtIndex:indexPath.row withObject:[NSNull null]];
            checkedamount  = checkedamount - [cell.lblTollPrice.text intValue];
            NSLog(@"Checked amount : %d",checkedamount);
        }
        
        else
        {
         cell.checkbutton.selected = !cell.checkbutton.selected;
           NSLog(@"Toll %@ selected",cell.lblTollName.text);
            
            [checkedtollListArray  replaceObjectAtIndex:indexPath.row withObject:[paidtollListArray objectAtIndex:indexPath.row]];
            checkedamount  = checkedamount + [cell.lblTollPrice.text intValue];
            
            NSLog(@"Checked amount : %d",checkedamount);
        }
        
       
        
        
    }
    
}

- (IBAction)didTapBringCheckBoxBtn:(id)sender {
    
    [_tblTollList setEditing:YES animated:YES];
}

-(void)removeAddedPlace:(UIButton*)sender{
    NSInteger selectedIndex = sender.tag;
    [addedPlaceArr removeObjectAtIndex:selectedIndex];
    CGRect frame =_addPlaceView.frame;
    frame.size.height = frame.size.height-70;
    _addPlaceView.frame = frame;
    _heightAddPlaceView.constant = frame.size.height;
    _tblViewAddRemovePlace .hidden = NO;
    [_tblViewAddRemovePlace reloadData];
}

-(void)showMoreDetailsforToll {
    isTollExtraDetailsShown = !isTollExtraDetailsShown;
    if(isTollExtraDetailsShown){
        tollInfoCellcount = 3;
        [_tblViewTollDetails reloadData];
        NSIndexPath* ip = [NSIndexPath indexPathForRow:2 inSection:0];
        [_tblViewTollDetails scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];

    }else{
        tollInfoCellcount = 2;
        [_tblViewTollDetails reloadData];
    }
}

-(void)fetchNearByTolls {
    float currentLatitude = [[[AppSinglton sharedManager] getLatitude] floatValue];
    float currentLongitude = [[[AppSinglton sharedManager] getLoongitude] floatValue];
    NSString *origin = [NSString stringWithFormat:@"%f,%f", currentLatitude, currentLongitude];
    NSDictionary* jsonInputParms=[[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"sfdg6565tyfgfgfgsad", @"SessionId",
                                  origin, @"Origin",
                                  nil];
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:@"http://nhtis.org/IOS/api/ver1/GRdST" parameters:jsonInputParms progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"JSON: %@", responseObject);
       
        tollListArray =[[responseObject objectForKey:@"TollInfo"] mutableCopy];
        
        [self addAllPins];
        
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLatitude
                                                                longitude:currentLongitude
                                                                     zoom:8];
      //  CGRect newFrame = CGRectMake( 0, 95, self.mapsizeview.frame.size.width, self.mapsizeview.frame.size.height
     //                                );
//        self.mapcontainer.frame = newFrame;
//        //self.mapView.frame = newFrame;
//        // _mapcontainer.frame = _mapsizeview.bounds;

        // _mapView = [GMSMapView mapWithFrame:newFrame camera:camera];
        [_mapView setCamera:camera];
        _mapView.myLocationEnabled = YES;
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [self showAlertWithTitle:@"" andMessage:@"Server Error! Please try again." andAction:NO];
    }];

}

-(void)searchEnroute{
    
    if(![_txtSourceCity.text length]){
        [self showAlertWithTitle:@"Source" andMessage:@"Please enter Source City Name" andAction:NO];
    }
    else if(![_txtDestinationCity.text length]){
        [self showAlertWithTitle:@"Destination" andMessage:@"Please enter Destination City Name" andAction:NO];
    }else{
        
        NSMutableString *viaString = [[NSMutableString alloc] init];
        for(NSString *placeName in addedPlaceArr){
            [viaString appendString:placeName];
            [viaString appendString:@"|"];
        }
        
        paysource = _txtSourceCity.text;
        paydestination = _txtDestinationCity.text;
    
    NSDictionary* jsonInputParms=[[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"sfdg6565tyfgfgfgsad", @"SessionId",
                                  _txtSourceCity.text, @"Origin",
                                  _txtDestinationCity.text, @"Destination",
                                  viaString, @"Waypoints",
                                  selectedVehicleId, @"VehicleTypeId",
                                  @"sfdg6565tyfgfgfgsad", @"Hash",
                                  nil];
    
     [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:@"http://nhtis.org/IOS/api/ver1/XrTsDT" parameters:jsonInputParms progress:nil success:^(NSURLSessionTask *task, id responseObject) {
         [SVProgressHUD dismiss];
          NSLog(@"JSON: %@", responseObject);
        totalamount = [responseObject objectForKey:@"TotalAmount"];
        _lblTotalDistance.text =[responseObject objectForKey:@"TotalDistance"];
        _lblTotalTime.text =[responseObject objectForKey:@"TotalTime"];
        NSLog(@"%@",_lblVehicle.text);
        _lblVehicleName.text = _lblVehicle.text;
        [[AppSinglton sharedManager] setEnrouteTollInfoData:[responseObject objectForKey:@"TollInfo"]];
        tollListArray =[[responseObject objectForKey:@"TollInfo"] mutableCopy];
        paidtollListArray = tollListArray;
        [_tblTollList reloadData];
        [self addAllPins];
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_sourceCoord.latitude
                                                                longitude:_sourceCoord.longitude
                                                                     zoom:7];
        [_mapView setCamera:camera];
        _mapView.myLocationEnabled = YES;
        [self makeRoute];
        // self.view = _mapView;
        

        [_viewTollInfoTable setHidden:NO];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
         [SVProgressHUD dismiss];
        [self showAlertWithTitle:@"" andMessage:@"Server Error! Please try again." andAction:NO];
    }];
    }
    
}


#pragma mark - TEXTFIELD Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField == _txtFldVehicles){
        _tblViewVehicles.hidden = NO;
        return NO;
    }
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
    if(textField == _txtFldVehicles){
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}




-(void)initViews
{
    //self.mapView = [[MKMapView alloc] init];
    self.mapView.delegate = self;
//    self.mapView.showsUserLocation = YES;
//    
//    MKCoordinateRegion region = self.mapView.region;
//    
//    region.center = CLLocationCoordinate2DMake(12.9752297537231, 80.2313079833984);
//    
//    region.span.longitudeDelta /= 1.0; // Bigger the value, closer the map view
//    region.span.latitudeDelta /= 1.0;
//    [self.mapView setRegion:region animated:NO]; // Choose if you want animate or not
    
    [self.view addSubview:self.mapView];
}

-(void)initConstraints
{
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    
    id views = @{
                 @"mapView": self.mapView
                 };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mapView]|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mapView]|" options:0 metrics:nil views:views]];
}

-(void)addAllPins
{
    self.mapView.delegate=self;
    
    for(int i = 0; i < tollListArray.count; i++)
    {
        [self addPinWithTitle:tollListArray[i][@"TollName"] AndCoordinate:tollListArray[i][@"TollLocation"]];
    }
   
}

-(void)addPinWithTitle:(NSString *)title AndCoordinate:(NSString *)strCoordinate
{    // clear out any white space
    strCoordinate = [strCoordinate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // convert string into actual latitude and longitude values
    NSArray *components = [strCoordinate componentsSeparatedByString:@","];
    
    double latitude = [components[0] doubleValue];
    double longitude = [components[1] doubleValue];
    
    // setup the map pin with all data and add to map view
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    GMSMarker *london = [GMSMarker markerWithPosition:coordinate];
    //london.
    london.title = title;
    london.icon = [UIImage imageNamed:@"location-icon"];
    london.map = _mapView;
    
    //[self.mapView addAnnotation:mapPin];
}


-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)imarker
{
    UIView *infowindow = [[UIView alloc] initWithFrame:imarker.panoramaView.frame];
    infowindow.backgroundColor=[UIColor clearColor];
     NSLog(@"Tapped %f", imarker.position.latitude);
    NSString *tollLocation = [NSString stringWithFormat:@"%f,%f", imarker.position.latitude, imarker.position.longitude];
    //[NSPredicate predicateWithFormat:@"Prefs == 1"]
    NSArray *clickedTollInfo = [tollListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"TollLocation == %@", tollLocation]];
    if(clickedTollInfo.count){
        NSInteger clickedTollId =[[[clickedTollInfo objectAtIndex:0] valueForKey:@"TollId"] integerValue];
        [self getTollDetailsForID : clickedTollId ];
    }
    
    return infowindow;
}

-(void)getTollDetailsForID : (NSInteger)tollID{
    
//https://nhtis.org/api/ver1/HSdYE
//    <TollDetailReq xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><SessionId>aaasd</SessionId><TollId>248</TollId></TollDetailReq>
    NSDictionary* jsonInputParms=[[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"sfdg6565tyfgfgfgsad", @"SessionId",
                                  [NSNumber numberWithInteger:tollID], @"TollId",
                                  nil];
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:@"http://nhtis.org/IOS/api/ver1/HSdYE" parameters:jsonInputParms progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        tollDetailInfo = responseObject;
            isTollExtraDetailsShown = NO;
            tollInfoCellcount = 2;
            [_tblViewTollDetails reloadData];
            _viewTollDetailsInfo.hidden = NO;
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [self showAlertWithTitle:@"" andMessage:@"Server Error! Please try again." andAction:NO];
    }];

    
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MKPointAnnotation *annotation = (MKPointAnnotation *)view.annotation;
  //  MKPointAnnotation *annotation=(MKPointAnnotation*)view.annotation;
    CLLocationCoordinate2D tappedCoord = annotation.coordinate;
    NSLog(@"vv");
}

-(void)makeRoute {
    NSString *urlString = [NSString stringWithFormat:
                           @"%@?origin=%f,%f&destination=%f,%f&sensor=true&key=%@",
                           @"https://maps.googleapis.com/maps/api/directions/json",
                           _sourceCoord.latitude,
                           _sourceCoord.longitude,
                           _destinitionCoord.latitude,
                           _destinitionCoord.longitude,
                           @"AIzaSyDoeOQSUhdYRC7IApvMbVJUcsJ6yZIoWAE"];
    NSURL *directionsURL = [NSURL URLWithString:urlString];
    
    
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"JSON: %@", responseObject);
        NSLog(@"%@",responseObject);
        NSDictionary *json =responseObject;
        GMSPath *path =[GMSPath pathFromEncodedPath:json[@"routes"][0][@"overview_polyline"][@"points"]];
        GMSPolyline *singleLine = [GMSPolyline polylineWithPath:path];
        singleLine.strokeWidth = 7;
        singleLine.strokeColor = [UIColor blueColor];
        singleLine.map = self.mapView;

        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [self showAlertWithTitle:@"" andMessage:@"Server Error! Please try again." andAction:NO];
    }];

}




-(void)gotoViewController:(NSString*)placeType{
    UIStoryboard* mainStoryBoard;
    mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    
    NearByListController* nearByListVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"NearByListController"];
    nearByListVC.searcPlaceType = placeType;
    [self.navigationController pushViewController:nearByListVC animated:YES];
}

- (IBAction)fineNearByTapped:(id)sender {
    _nearByOptions.hidden = !_nearByOptions.hidden;
}

- (IBAction)restaurantTapped:(id)sender {
    [self gotoViewController:@"restaurant"];
}
- (IBAction)petroTapped:(id)sender {
    [self gotoViewController:@"gas_station"];
}
- (IBAction)atmTapped:(id)sender {
    [self gotoViewController:@"atm"];
}
- (IBAction)hospitalsTapped:(id)sender {
    [self gotoViewController:@"hospital"];
}


@end
