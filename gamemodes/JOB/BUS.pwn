//======== Bus ===========
enum E_BUS
{
    STREAMER_TAG_MAP_ICON:BusMap,
	STREAMER_TAG_CP:BusCp,
	STREAMER_TAG_MAP_ICON:BusMapBaru,
	STREAMER_TAG_CP:BusCpBaru
}
new BusArea[MAX_PLAYERS][E_BUS];

DeleteBusCP(playerid)
{
	if(IsValidDynamicCP(BusArea[playerid][BusCp]))
	{
		DestroyDynamicCP(BusArea[playerid][BusCp]);
		BusArea[playerid][BusCp] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicMapIcon(BusArea[playerid][BusMap]))
	{
		DestroyDynamicMapIcon(BusArea[playerid][BusMap]);
		BusArea[playerid][BusMap] = STREAMER_TAG_MAP_ICON: -1;
	}
	if(IsValidDynamicCP(BusArea[playerid][BusCpBaru]))
	{
		DestroyDynamicCP(BusArea[playerid][BusCpBaru]);
		BusArea[playerid][BusCpBaru] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicMapIcon(BusArea[playerid][BusMapBaru]))
	{
		DestroyDynamicMapIcon(BusArea[playerid][BusMapBaru]);
		BusArea[playerid][BusMapBaru] = STREAMER_TAG_MAP_ICON: -1;
	}
}

RefreshJobBus(playerid)
{
	DeleteBusCP(playerid);

	if(pData[playerid][pJob] == 1)
	{
		BusArea[playerid][BusCp] = CreateDynamicCP(1245.016601,-2020.109741,59.889400, 2.0, -1, -1, playerid, 30.0);
		BusArea[playerid][BusMap] = CreateDynamicMapIcon(1245.016601,-2020.109741,59.889400, 61, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
		BusArea[playerid][BusCpBaru] = CreateDynamicCP(-609.8121,-507.1617,25.7228, 2.0, -1, -1, playerid, 30.0);
		BusArea[playerid][BusMapBaru] = CreateDynamicMapIcon(-609.8121,-507.1617,25.7228, 61, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
	}
	return 1;
}

#define buspoint1 		1280.061767,-2059.221923,59.007038
#define buspoint2 		1406.055297,-2042.139648,54.090114
#define buspoint3 		1388.694702,-1967.259033,36.970306
#define buspoint4 		1274.351928,-1944.078491,29.449188
#define buspoint5 		1314.175903,-1915.889160,23.581806
#define buspoint6 		1428.827514,-1898.697509,13.864680
#define buspoint7 		1486.388183,-1874.732299,13.483360
#define buspoint8 		1527.490722,-1922.029785,15.756288
#define buspoint9 		1529.773315,-2037.733764,30.656585
#define buspoint10 		1611.311889,-2151.531005,26.838613
#define buspoint11 		1789.403564,-2168.911621,13.483464
#define buspoint12 		1935.325927,-2169.052978,13.483065
#define buspoint13 		1964.242919,-2070.636230,13.494494
#define buspoint14 		1964.018798,-1907.571533,13.483125
#define buspoint15 		1965.075073,-1779.868530,13.479113
#define buspoint16 		2060.129394,-1755.007446,13.488880
#define buspoint17 		2160.542480,-1755.085693,13.485799
#define buspoint18 		2198.407714,-1732.569335,13.494822
#define buspoint19 		2216.002197,-1875.839477,13.483457
#define buspoint20 		2216.152343,-2013.465087,13.449681
#define buspoint21 		2339.216552,-2139.990478,15.328786
#define buspoint22 		2464.309570,-2264.988769,25.163112
#define buspoint23 		2563.019287,-2363.141357,15.987734
#define buspoint24 		2670.505859,-2407.984619,13.555817
#define buspoint25 		2758.318359,-2430.743164,13.597185
#define buspoint26 		2763.975097,-2479.834228,13.575368
#define buspoint27 		2659.496582,-2501.279052,13.589831
#define buspoint28		2532.097412,-2501.937988,13.636500
#define buspoint29		2482.001953,-2577.090576,13.606858
#define buspoint30		2409.167968,-2660.492431,13.627305
#define buspoint31		2257.277099,-2661.927734,13.542902
#define buspoint32 		2227.485107,-2538.904296,13.509632
#define buspoint33 		2187.636474,-2492.173828,13.477516
#define buspoint34 		2158.403320,-2569.258544,13.475986
#define buspoint35 		2085.054687,-2665.911376,13.479298
#define buspoint36		1917.729125,-2668.174560,6.034108
#define buspoint37 		1783.769409,-2669.453857,5.979684
#define buspoint38 		1638.428466,-2669.250488,5.967841
#define buspoint39 		1472.686035,-2669.243164,11.927350
#define buspoint40 		1350.609497,-2578.896972,13.475920
#define buspoint41		1348.375732,-2405.036865,13.475702
#define buspoint42 		1361.083129,-2297.251708,13.486678
#define buspoint43 		1470.698364,-2334.642333,13.482721
#define buspoint44 		1559.332519,-2289.056396,13.486524
#define buspoint45 		1661.341674,-2321.407958,13.483482
#define buspoint46 		1735.662109,-2282.550292,13.475940
#define buspoint47 		1697.473754,-2250.877929,13.482275
#define buspoint48		1562.058715,-2283.249267,13.483885
#define buspoint49 		1473.046752,-2237.903320,13.483382
#define buspoint50 		1394.131225,-2282.712158,13.460983
#define buspoint51  	1325.282470,-2386.672119,13.475554
#define buspoint52 		1261.956054,-2444.065429,8.715504
#define buspoint53 		1149.169677,-2391.894531,11.152619
#define buspoint54      1042.016845,-2242.414794,13.042969
#define buspoint55		1051.437133,-2061.033691,13.037005
#define buspoint56      1060.096801,-1859.927856,13.488168
#define buspoint57      1164.005981,-1854.715087,13.497838
#define buspoint58      1235.685913,-1855.510986,13.481544//stop ke 3
#define buspoint59      1356.235473,-1867.938354,13.483355
#define buspoint60      1423.378295,-1903.542480,13.874370
#define buspoint61      1303.339843,-1907.860839,24.613706
#define buspoint62      1307.518798,-1958.998779,29.257463
#define buspoint63  	1426.418212,-1996.640136,50.198066
#define buspoint64      1295.822021,-2053.925292,58.574115
#define buspoint65      1260.515625,-2015.804565,59.541069
//rute bus 2
#define cpbus1 			-539.2806,-523.2104,25.7253
#define cpbus2 			-476.5073,-609.8909,17.3272
#define cpbus3 			-415.1812,-590.5543,11.1846
#define cpbus4 			-506.5304,-393.9781,16.1062
#define cpbus5 		 	-745.1449,-433.4766,16.0646
#define cpbus6 			-886.3450,-463.4493,23.9646
#define cpbus7 			-961.6530,-334.2141,36.2477
#define cpbus8 			-805.1191,-114.1556,63.6200
#define cpbus9 			-747.6723,-5.7273,53.1510
#define cpbus10			-792.6533,14.2269,33.3707
#define cpbus11			-717.3571,119.0333,15.7373
#define cpbus12			-523.2466,282.3461,2.1802
#define cpbus13			-165.7437,364.8784,12.1787
#define cpbus14			-126.4580,580.5178,2.7789
#define cpbus15			-288.5711,639.5784,16.1828
#define cpbus16			-154.0040,742.2755,22.9539
#define cpbus17			-174.6440,814.0516,22.0599
#define cpbus18			-190.7349,947.6729,16.1827
#define cpbus19			-217.3658,1021.0369,19.6915
#define cpbus20			-272.9776,1115.6296,19.6915
#define cpbus21			-224.6271,1196.1451,19.6950
#define cpbus22			85.4105,1195.3680,18.4908
#define cpbus23			164.0048,1150.3789,14.4663
#define cpbus24			333.4113,1344.2068,8.9199
#define cpbus25			473.6363,1640.8574,15.3603
#define cpbus26			615.5842,1697.0778,7.0947
#define cpbus27			649.4136,1780.5033,5.3463
#define cpbus28			725.2737,1912.1259,5.6434
#define cpbus29			807.5643,1836.6034,3.8919
#define cpbus30			821.2609,1531.5461,17.7272
#define cpbus31			770.3237,1125.1390,28.4193
#define cpbus32			348.2410,1011.1359,28.4536
#define cpbus33			254.7596,913.1982,24.4566
#define cpbus34			479.3594,526.2183,19.0221
#define cpbus35			589.1198,369.5509,19.0410
#define cpbus36			554.4610,273.6255,16.7298
#define cpbus37			517.8661,146.1436,24.0598
#define cpbus38			526.4655,-109.1321,37.2908
#define cpbus39			461.9476,-425.0762,29.2536
#define cpbus40			314.8308,-564.7679,40.4776
#define cpbus41			222.9891,-612.4483,29.5597
#define cpbus42			84.0509,-667.4488,5.3399
#define cpbus43			-14.6675,-756.7159,8.2910
#define cpbus44			-117.7939,-969.9329,24.9792
#define cpbus45			-278.8258,-879.2018,45.9452
#define cpbus46			-283.2650,-822.9532,42.7230
#define cpbus47			-344.4633,-779.8657,30.8549
#define cpbus48			-387.0900,-685.6909,19.0988
#define cpbus49			-475.5967,-618.2720,17.2350
#define cpbus50			-485.2985,-544.7413,25.7223
#define cpbus51			-522.4493,-516.2531,25.7162
#define cpbus52			-547.2876,-515.8419,25.7220
