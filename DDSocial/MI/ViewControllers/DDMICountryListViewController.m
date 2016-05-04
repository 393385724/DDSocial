//
//  DDMICountryListViewController.m
//  DDMISDKDemo
//
//  Created by lilingang on 16/4/29.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDMICountryListViewController.h"

NSString *const DDMICountryNameKey     = @"DDMICountryNameKey";
NSString *const DDMICountryAreaCodeKey = @"DDMICountryAreaCodeKey";

@interface DDMICountryListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation DDMICountryListViewController{
    NSArray *_sectionIndexTitles;
    NSMutableArray *_commonCountryArray;//**通用的国家*/
    NSMutableArray *_otherCountryArray; //**其他国家*/
}

- (instancetype)init{
    self = [super initWithNibName:@"DDMICountryListViewController" bundle:MIResourceBundle];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = MILocal(@"国家或地区");
    self.myTableView.rowHeight = 36.0;
    
    _sectionIndexTitles = @[@"",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"Y",@"Z"];
    
    //通用国家
    NSArray *commonOriginArray = [NSArray arrayWithObjects:@"中国(+86)",@"台灣(+886)",@"中國香港(+852)",@"Brazil(+55)",@"India(+91)",@"Indonesia(+62)",@"Malaysia(+60)", nil];
    _commonCountryArray = [[NSMutableArray alloc] init];
    for (NSString *string in commonOriginArray) {
        [_commonCountryArray addObject:[self processOriginCountryString:string]];
    }
    
    //其他国家
    NSArray *otherOriginCountryArray = [NSArray arrayWithObjects:@"Afghanistan(+93)", @"Albania(+355)",@"Algeria(+213)",@"American Samoa(+1684)",@"Andorra(+376)",@"Angola(+244)",@"Anguilla(+1264)",@"Antarctica(+672)",@"Antigua and Barbuda(+1268)",@"Argentina(+54)",@"Armenia(+374)",@"Aruba(+297)",@"Australia(+61)",@"Austria(+43)",@"Azerbaijan(+994)",@"Bahamas(+1242)",@"Bahrain(+973)",@"Bangladesh(+880)",@"Barbados(+1246)"@"Belarus(+375)",@"Belgium(+32)",@"Belize(+501)",@"Benin(+229)",@"Bermuda(+1441)",@"Bhutan(+975)",@"Bolivia(+591)",@"Bosnia and Herzegovina(+387)",@"Botswana(+267)"@"Brazil(+55)",@"British Virgin Islands(+1284)",@"Brunei(+673)",@"Bulgaria(+359)",@"Burkina Faso(+226)",@"Burma (Myanmar)(+95)",@"Burundi(+257)",@"Cambodia(+855)",@"Cameroon(+237)",@"Canada(+1)",@"Cape Verde(+238)",@"Cayman Islands(+1345)",@"Central African Republic(+236)",@"Chad(+235)",@"Chile(+56)",@"China(+86)",@"Christmas Island(+61)",@"Cocos (Keeling) Islands(+61)",@"Colombia(+57)",@"Comoros(+269)",@"Cook Islands(+682)",@"Costa Rica(+506)",@"Croatia(+385)",@"Cuba(+53)",@"Cyprus(+357)",@"Czech Republic(+420)",@"Democratic Republic of the Congo(+243)",@"Denmark(+45)",@"Djibouti(+253)",@"Dominica(+1767)",@"Dominican Republic(+1809)",@"Ecuador(+593)",@"Egypt(+20)",@"El Salvador(+503)",@"Equatorial Guinea(+240)",@"Eritrea(+291)",@"Estonia(+372)",@"Ethiopia(+251)",@"Falkland Islands(+500)",@"Faroe Islands(+298)",@"Fiji(+679)",@"Finland(+358)",@"France (+33)",@"French Polynesia(+689)",@"Gabon(+241)",@"Gambia(+220)",@"Gaza Strip(+970)",@"Georgia(+995)",@"Germany(+49)",@"Ghana(+233)",@"Gibraltar(+350)",@"Greece(+30)",@"Greenland(+299)",@"Grenada(+1473)",@"Guam(+1671)",@"Guatemala(+502)",@"Guinea(+224)",@"Guinea-Bissau(+245)",@"Guyana(+592)",@"Haiti(+509)",@"Holy See (Vatican City)(+39)",@"Honduras(+504)",@"Hong Kong(+852)",@"Hungary(+36)",@"Iceland(+354)",@"India(+91)",@"Indonesia(+62)",@"Iran(+98)",@"Iraq(+964)",@"Ireland(+353)",@"Isle of Man(+44)",@"Israel(+972)",@"Italy(+39)",@"Ivory Coast(+225)",@"Jamaica(+1876)",@"Japan(+81)",@"Jordan(+962)",@"Kazakhstan(+7)",@"Kenya(+254)",@"Kiribati(+686)",@"Kosovo(+381)",@"Kuwait(+965)",@"Kyrgyzstan(+996)",@"Laos(+856)",@"Latvia(+371)",@"Lebanon(+961)",@"Lesotho(+266)",@"Liberia(+231)",@"Libya(+218)",@"Liechtenstein(+423)",@"Lithuania(+370)",@"Luxembourg(+352)",@"Macau(+853)",@"Macedonia(+389)",@"Madagascar(+261)",@"Malawi(+265)",@"Malaysia(+60)",@"Maldives(+960)",@"Mali(+223)",@"Malta(+356)",@"MarshallIslands(+692)",@"Mauritania(+222)",@"Mauritius(+230)",@"Mayotte(+262)",@"Mexico(+52)",@"Micronesia(+691)",@"Moldova(+373)",@"Monaco(+377)",@"Mongolia(+976)",@"Montenegro(+382)",@"Montserrat(+1664)",@"Morocco(+212)",@"Mozambique(+258)",@"Namibia(+264)",@"Nauru(+674)",@"Nepal(+977)",@"Netherlands(+31)",@"Netherlands Antilles(+599)",@"New Caledonia(+687)",@"New Zealand(+64)",@"Nicaragua(+505)",@"Niger(+227)",@"Nigeria(+234)",@"Niue(+683)",@"Norfolk Island(+672)",@"North Korea (+850)",@"Northern Mariana Islands(+1670)",@"Norway(+47)",@"Oman(+968)",@"Pakistan(+92)",@"Palau(+680)",@"Panama(+507)",@"Papua New Guinea(+675)",@"Paraguay(+595)",@"Peru(+51)",@"Philippines(+63)",@"Pitcairn Islands(+870)",@"Poland(+48)",@"Portugal(+351)",@"Puerto Rico(+1)",@"Qatar(+974)",@"Republic of the Congo(+242)",@"Romania(+40)",@"Russia(+7)",@"Rwanda(+250)",@"Saint Barthelemy(+590)",@"Saint Helena(+290)",@"Saint Kitts and Nevis(+1869)",@"Saint Lucia(+1758)",@"Saint Martin(+1599)",@"Saint Pierre and Miquelon(+508)",@"Saint Vincent and the Grenadines(+1784)",@"Samoa(+685)",@"San Marino(+378)",@"Sao Tome and Principe(+239)",@"Saudi Arabia(+966)",@"Senegal(+221)",@"Serbia(+381)",@"Seychelles(+248)",@"Sierra Leone(+232)",@"Singapore(+65)",@"Slovakia(+421)",@"Slovenia(+386)",@"Solomon Islands(+677)",@"Somalia(+252)",@"South Africa(+27)",@"South Korea(+82)",@"Spain(+34)",@"Sri Lanka(+94)",@"Sudan(+249)",@"Suriname(+597)",@"Swaziland(+268)",@"Sweden(+46)",@"Switzerland(+41)",@"Syria(+963)",@"Taiwan(+886)",@"Tajikistan(+992)",@"Tanzania(+255)",@"Thailand(+66)",@"Timor-Leste(+670)",@"Togo(+228)",@"Tokelau(+690)",@"Tonga(+676)",@"Trinidad and Tobago(+1868)",@"Tunisia(+216)",@"Turkey(+90)",@"Turkmenistan(+993)",@"Turks and Caicos Islands(+1649)",@"Tuvalu(+688)",@"Uganda(+256)",@"Ukraine(+380)",@"United Arab Emirates(+971)",@"United Kingdom(+44)",@"United States(+1)",@"Uruguay(+598)",@"US Virgin Islands(+1340)",@"Uzbekistan(+998)",@"Vanuatu(+678)",@"Venezuela(+58)",@"Vietnam(+84)",@"Wallis and Futuna(+681)",@"West Bank(970)",@"Yemen(+967)",@"Zambia(+260)",@"Zimbabwe(+263)",nil];
    
    NSMutableArray *sectionDataSourceArray = [[NSMutableArray alloc] init];
    NSInteger sectionIndex = 1;
    _otherCountryArray = [[NSMutableArray alloc] init];
    for (NSString *string in otherOriginCountryArray) {
        NSDictionary *dict = [self processOriginCountryString:string];
        NSString *countryName = dict[DDMICountryNameKey];
        NSString *sectionTitle = _sectionIndexTitles[sectionIndex];
        if ([[countryName substringWithRange:NSMakeRange(0, 1)] isEqualToString:sectionTitle]) {
            [sectionDataSourceArray addObject:dict];
        } else {
            [_otherCountryArray addObject:sectionDataSourceArray];
            sectionIndex ++;
            sectionDataSourceArray = [[NSMutableArray alloc] init];
            [sectionDataSourceArray addObject:dict];
        }
    }
    [_otherCountryArray addObject:sectionDataSourceArray];
}

#pragma mark - Template Methods

- (DDMINavigationLeftBarAction)leftBarAction{
    return DDMINavigationLeftBarActionBack;
}

#pragma mark - Private Methods
/**
 *  @brief 将原始国家地区字符串解析为国家和区号
 *
 *  @param countryString eg 中国(+86)
 *
 *  @return NSDictionary @{DDMICountryNameKey:@"中国",DDMICountryAreaCodeKey:@"+86"}
 */
- (NSDictionary *)processOriginCountryString:(NSString *)countryString{
    NSString *tmpString = [countryString stringByReplacingOccurrencesOfString:@")" withString:@""];
    NSArray *tmpArray = [tmpString componentsSeparatedByString:@"("];
    return @{DDMICountryNameKey:[tmpArray firstObject],DDMICountryAreaCodeKey:[tmpArray lastObject]};
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sectionIndexTitles count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width-15, 20)];
    bgView.backgroundColor = [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1];
    [headerView addSubview:bgView];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 20)];
    [titleLbl setFont:[UIFont boldSystemFontOfSize:12]];
    titleLbl.backgroundColor = [UIColor clearColor];
    [headerView addSubview:titleLbl];
    if (section == 0) {
        titleLbl.text = MILocal(@"常用");
    } else {
        titleLbl.text = [_sectionIndexTitles objectAtIndex:section];
    }
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 7;
    } else {
        return [_otherCountryArray[section - 1] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"UITableViewCell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    NSDictionary *dict;
    if (indexPath.section == 0) {
        dict = _commonCountryArray[indexPath.row];
    } else if (indexPath.section > 0) {
        dict = _otherCountryArray[indexPath.section-1][indexPath.row];
    }
    cell.textLabel.text = dict[DDMICountryNameKey];
    cell.detailTextLabel.text = dict[DDMICountryAreaCodeKey];
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _sectionIndexTitles;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict;
    if (indexPath.section == 0) {
        dict = _commonCountryArray[indexPath.row];
    } else {
        dict = _otherCountryArray[indexPath.section-1][indexPath.row];
    }

    if ([self.delegate respondsToSelector:@selector(countryListViewControllerDidSelectedCountryName:code:)]) {
        [self.delegate countryListViewControllerDidSelectedCountryName:dict[DDMICountryNameKey] code:dict[DDMICountryAreaCodeKey]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
