/*

	SISTEM FURNITURE

*/


#define MODEL_SELECTION_FURNITURE 	1

#define THREAD_LOAD_FURNITURE       1
#define THREAD_COUNT_FURNITURE     	2
#define THREAD_SELL_FURNITURE       3
#define THREAD_CLEAR_FURNITURE      4


///=======================================

	enum furnitureEnum
{
	fCategory[24],
    fName[32],
    fModel,
    fPrice
};
new const furnitureCategories[][] =
{
	{"Peralatan"},
	{"Kamar Mandi"},
	{"Kamar Tidur"},
	{"Karpet"},
	{"Dapur"},
	{"Meja"},
	{"Kursi"},
	{"Poster/Bingkai"},
	{"Penyimpanan"},
	{"Tanaman"},
	{"Sampah"},
	{"Pintu & Gerbang"},
	{"Tembok"},
	{"Dekorasi"},
	{"Efek"},
	{"Spesial"},
	{"Graffiti"},
	{"Campur"}
};

new const furnitureArray[][furnitureEnum] =
{
	{"Peralatan", 		"Blender", 					 19830,  1000},
	{"Peralatan", 		"Coffee machine",            11743,  1000},
	{"Peralatan", 		"Grill",     				 19831,  1000},
	{"Peralatan", 		"Electrical outlet", 		 19813,  550},
	{"Peralatan", 		"Light switch",      		 19829,  550},
	{"Peralatan", 		"Keyboard",          		 19808,  550},
	{"Peralatan", 		"White telephone",   		 19807,  550},
	{"Peralatan", 		"Black telephone",   		 11705,  550},
	{"Peralatan", 		"Large LCD television",  	 19786,  1000},
    {"Peralatan", 		"Small LCD television",  	 19787,  7550},
    {"Peralatan", 		"Round gold TV", 			 2224,   11000},
    {"Peralatan", 		"TV on wheels",  			 14532,  2550},
    {"Peralatan", 		"Flat screen TV",        	 1792,   400},
    {"Peralatan",      "Wide screen TV",        	 1786,   400},
    {"Peralatan",      "Surveillance TV",       	 1749,   400},
    {"Peralatan",      "Regular TV",            	 1518,   2550},
    {"Peralatan",      "Grey sided TV",         	 2322,   200},
    {"Peralatan",      "Wood sided TV",         	 1429,   200},
    {"Peralatan",      "Microwave",             	 2149,   800},
    {"Peralatan",      "Pizza rack",            	 2453,   550},
    {"Peralatan",      "Wide sprunk fridge",  		 2452,   800},
    {"Peralatan",      "Small sprunk fridge",   	 2533,   550},
    {"Peralatan",      "Duality game",        		 2779,   1000},
    {"Peralatan",      "Bee Bee Gone game",   		 2778,   1000},
    {"Peralatan",      "Space Monkeys game",    	 2681,   1000},
    {"Peralatan",      "Sprunk machine",        	 1775,   1000},
    {"Peralatan",      "Candy machine",         	 1776,   1000},
    {"Peralatan",      "Water machine",         	 1808,   800},
    {"Peralatan",      "Radiator",              	 1738,   550},
    {"Peralatan",      "Metal fridge",          	 1780,   800},
    {"Peralatan",      "Pizza cooker",         	 	 2426,   550},
    {"Peralatan",      "Deep fryer",            	 2415,   800},
    {"Peralatan",      "Soda dispenser",        	 2427,   800},
    {"Peralatan",      "Aluminum stove",        	 2417,   800},
    {"Peralatan",      "Lamp",                  	 2105,   550},
    {"Peralatan",      "Diagnostic machine",    	 19903,  4000},
    {"Peralatan",      "VHS player",            	 1785,   200},
    {"Peralatan",      "Playstation console",   	 2028,   1000},
    {"Peralatan",      "Retro gaming console",  	 1718,   1000},
    {"Peralatan",      "Hi-Fi speaker",         	 1839,   2550},
    {"Peralatan",      "Black subwoofer",       	 2232,   2550},
    {"Peralatan",      "Subwoofer",             	 1840,   2550},
    {"Peralatan",      "Small black speaker",   	 2229,   2550},
    {"Peralatan",      "Speaker on a stand",    	 2233,   800},
    {"Peralatan",      "Speaker & stereo system",    2099,   1000},
	{"Peralatan",      "Surveillance camera",   	 1886,   550},
	{"Peralatan",      "Security camera",       	 1622,   550},
	{"Peralatan",      "Exercise bike",         	 2630,   1000},
	{"Peralatan",      "Treadmill",             	 2627,   1000},
	{"Peralatan",      "Lift bench",            	 2629,   2550},
    {"Peralatan",		"Pull up machine",       	 2628,   1000},
    {"Peralatan", 		"White turntable",           1954,   1000},
    {"Kamar Mandi",   	"Toilet",                	 2514,   2550},
    {"Kamar Mandi",   	"Bathtub",               	 2519,   1000},
    {"Kamar Mandi",   	"Toilet paper",          	 19873,  550},
    {"Kamar Mandi",     "Towel rack",                11707,  800},
    {"Kamar Mandi",   	"Toilet with rug",       	 2528,   1000},
	{"Kamar Mandi",     "Toilet with rolls",     	 2525,   1000},
	{"Kamar Mandi",   	"Sink top",              	 2515,   800},
	{"Kamar Mandi",   	"Dual sink top",         	 2150,   200},
	{"Kamar Mandi",   	"Wood sided bathtub",    	 2526,   1000},
	{"Kamar Mandi",   	"Sprunk bathtub",        	 2097,   1000},
	{"Kamar Mandi",  	"Shower curtains",       	 14481,  800},
	{"Kamar Mandi",   	"Metal shower cabin",    	 2520,   1000},
	{"Kamar Mandi",   	"Glass shower cabin",    	 2517,   1000},
	{"Kamar Mandi",   	"Shower with curtains",  	 2527,   1000},
	{"Kamar Mandi",   	"Wall sink",             	 2518,   2550},
	{"Kamar Mandi",   	"Plain sink",            	 2739,   2550},
	{"Kamar Mandi",   	"Sink with extra soap",  	 2524,   2550},
	{"Kamar Mandi",   	"Sink with rug",         	 2523,   2550},
	{"Kamar Mandi",   	"Industrial sink",       	 11709,  1000},
	{"Kamar Tidur",    	"Prison bed",            	 1800,   800},
	{"Kamar Tidur",   	"Folding bed",           	 1812,   800},
	{"Kamar Tidur",    	"Red double bed",        	 11720,  1000},
	{"Kamar Tidur",    	"Wood double bed",       	 14866,  1000},
	{"Kamar Tidur",   	 "Double plaid bed",      	 1794,   1000},
	{"Kamar Tidur",    	"Brown bed",        		 2229,   1000},
	{"Kamar Tidur",    	"Blue striped bed", 		 2302,   1000},
	{"Kamar Tidur",    	"Dark blue striped bed", 	 2298,   1000},
	{"Kamar Tidur",    	"White striped bed",     	 2090,   1000},
	{"Kamar Tidur",    	"Bed with cabinet",      	 2300,   1000},
	{"Kamar Tidur",    	"Pink & blue striped bed", 	 2301,   1000},
	{"Kamar Tidur",    	"Zebra print bed",       	 14446,  1000},
	{"Kamar Tidur",    	"Low striped bed",  		 1795,   1000},
	{"Kamar Tidur",    	"Low dark striped bed",      1798,   1000},
	{"Kamar Tidur",    	"Single plaid bed",      	 1796,   1000},
	{"Kamar Tidur",    	"Plain striped mattress",    1793,   1000},
	{"Kamar Tidur",    	"Silk sheeted bed",          1701,   1000},
	{"Kamar Tidur",    	"Framed striped bed",        1801,   1000},
	{"Kamar Tidur",    	"Framed brown bed",          1802,   1000},
	{"Kamar Tidur",    	"Wooden cabinet",            2330,   2550},
	{"Kamar Tidur",    	"Cabinet with TV",           2296,   1000},
	{"Kamar Tidur",    	"Dresser",               	 1416,   2550},
	{"Kamar Tidur",    	"Small dresser",             2095,   2550},
	{"Kamar Tidur",    	"Medium dresser",            1743,   2550},
	{"Kamar Tidur",    	"Wide dresser",              2087,   2550},
	{"Kamar Tidur",    	"Small wardrobe",            2307,   2550},
	{"Kamar Tidur",  	"Huge open wardrobe",        14556,  1000},
	{"Kamar Tidur",    	"Busted cabinet",            913,    1000},
	{"Kamar Tidur",    	"Busted dresser",            911,    2550},
	{"Kamar Tidur",    	"Dresser with no drawers",   912,    800},
	{"Karpet",    		"Rockstar carpet",           11737,  2550},
    {"Karpet",    		"Plain red carpet",          2631,   2550},
    {"Karpet",    		"Plain green carpet",        2632,   2550},
    {"Karpet",    		"Patterned carpet",          2842,   2550},
    {"Karpet",    		"Zig-zag patterned carpet",  2836,   2550},
    {"Karpet",    		"Brown red striped carpet",  2847,   2550},
    {"Karpet",    		"Old timer's carpet",        2833,   2550},
    {"Karpet",    		"Red checkered carpet",      2818,   2550},
    {"Karpet",    		"Green circled carpet",      2817,   2550},
    {"Karpet",    		"Plain polkadot carpet",     2834,   2550},
    {"Karpet",    		"Tiger rug",                 1828,   1000},
    {"Karpet",    		"Plain round rug",           2835,   2550},
    {"Karpet",    		"Round green rug",           2841,   2550},
    {"Dapur",    		"CJ's kitchen",              14384,  3000},
    {"Dapur",    		"Whole kitchen",             14720,  3000},
    {"Dapur",    		"White kitchen sink",        2132,   1000},
    {"Dapur",    		"White kitchen counter",  	 2134,   1000},
    {"Dapur",    		"White kitchen fridge",      2131,   1000},
    {"Dapur",    		"White kitchen drawers",     2133,   1000},
    {"Dapur",    		"White kitchen corner",      2341,   1000},
    {"Dapur",    		"White kitchen cupboard",    2141,   1000},
    {"Dapur",    		"Green kitchen sink",        2336,   1000},
    {"Dapur",    		"Green kitchen counter",     2334,   1000},
    {"Dapur",    		"Green kitchen fridge",      2147,   1000},
    {"Dapur",    		"Green kitchen corner",      2338,   1000},
    {"Dapur",    		"Green kitchen washer",      2337,   1000},
    {"Dapur",    		"Green kitchen cupboard",    2158,   1000},
    {"Dapur",    		"Green kitchen stove",       2170,   1000},
    {"Dapur",    		"Red kitchen sink",          2130,   1000},
    {"Dapur",    		"Red kitchen fridge",        2127,   1000},
    {"Dapur",    		"Red kitchen cupboard",      2128,   1000},
    {"Dapur",    		"Red kitchen corner",        2304,   1000},
    {"Dapur",    		"Red kitchen counter",       2129,   1000},
    {"Dapur",    		"Wood kitchen sink",         2136,   1000},
    {"Dapur",    		"Wood kitchen counter",      2139,   1000},
    {"Dapur",    		"Wood kitchen cupboard",     2140,   1000},
    {"Dapur",    		"Wood kitchen washer",       2303,   1000},
    {"Dapur",    		"Wood kitchen unit",         2138,   1000},
    {"Dapur",    		"Wood kitchen corner",       2305,   1000},
    {"Dapur",    		"Wood kitchen stove",        2135,   1000},
    {"Dapur",    		"Modern stove",              19923,  1000},
    {"Dapur",    		"Old timer's stove",         19915,  1000},
    {"Dapur",    		"Fork",                      11715,  550},
    {"Dapur",    		"Butter knife",              11716,  550},
    {"Dapur",    		"Steak knife",               19583,  550},
    {"Dapur",    		"Spatula",                   19586,  550},
    {"Dapur",    		"Double handled pan",        19585,  800},
    {"Dapur",    		"Single handled pan",        19584,  800},
    {"Dapur",    		"Frying pan",                19581,  800},
    {"Dapur",    		"Tall striped saucepan",     11719,  800},
    {"Dapur",    		"Striped saucepan",          11718,  800},
    {"Dapur",    		"Cooked steak",              19982,  550},
    {"Dapur",    		"Raw steak",                 19582,  550},
    {"Dapur",    		"Green apple",               19576,  550},
    {"Dapur",    		"Red apple",                 19575,  550},
    {"Dapur",    		"Orange",                    19574,  550},
    {"Dapur",    		"Banana",                    19578,  550},
    {"Dapur",           "Tomato",                    19577,  550},
    {"Meja",     		"Lab table",                 3383,   2000},
    {"Meja",     		"Pool table",                2964,   2000},
    {"Meja",     		"Blackjack table",           2188,   2000},
    {"Meja",     		"Betting table",             1824,   2000},
    {"Meja",     		"Roulette table",            1896,   2000},
    {"Meja",     		"Poker table",               19474,  1000},
    {"Meja",     		"Burger shot table",         2644,   1000},
    {"Meja",     		"Cluckin' bell table",       2763,   1000},
    {"Meja",     		"Wide cluckin' bell table",  2762,   1000},
    {"Meja",     		"Square coffee table",       2370,   1000},
    {"Meja",     		"Donut shop table",          2747,   1000},
    {"Meja",     		"Pizza table",               2764,   1000},
    {"Meja",     		"Wide coffee table",         2319,   1000},
    {"Meja",     		"Rectangular green table",   11691,  1000},
    {"Meja",     		"Squared green table",       11690,  1000},
    {"Meja",     		"Round glass table",         1827,   1000},
    {"Meja",     		"Round wooden table",        2111,   1000},
    {"Meja",     		"Wide dining table",         2357,   1000},
    {"Meja",     		"Plain wooden table",        2115,   1000},
    {"Meja",     		"Plain brown wooden table",  1516,   1000},
    {"Meja",     		"White polkadot table",      1770,   1000},
    {"Meja",     		"Brown dining table",        1737,   1000},
    {"Meja",     		"Round stone table",         2030,   1000},
    {"Meja",     		"Wooden table with rim",     2699,   1000},
    {"Meja",     		"Low coffee table",          1814,   1000},
    {"Meja",     		"Low brown wooden table",    1433,   1000},
    {"Meja",     		"Bedroom table",             2333,   1000},
    {"Meja",     		"Round table with chairs",   1432,   1000},
    {"Meja",     		"Table with benches",        1281,   1000},
    {"Meja",     		"Checkered table & chairs",  1594,   1000},
    {"Meja",     		"Wooden workshop table",     19922,  1000},
    {"Meja",     		"Hexagon shaped table",      2725,   1000},
    {"Meja",     		"Table with VCR",            2313,   1000},
    {"Meja",     		"Low wooden TV stand",       2314,   1000},
    {"Meja",     		"Low brown TV stand",        2315,   1000},
    {"Meja",     		"Plain brown office desk",   2206,   1000},
    {"Meja",     		"Office desk with computer", 2181,   1000},
    {"Meja",     		"Plain wooden office desk",  2185,   1000},
    {"Meja",     		"Computer desk",             2008,   1000},
    {"Kursi",     		"Blue swivel chair",         2356,   2550},
    {"Kursi",     		"Brown dining chair",        1811,   2550},
    {"Kursi",     		"Red folding chair",         2121,   2550},
    {"Kursi",    		"Upholstered chair",         2748,   1000},
    {"Kursi",     		"Folding office chair",      1721,   2550},
    {"Kursi",     		"Round black chair",         2776,   2550},
    {"Kursi",     		"Black stool",               1716,   2550},
    {"Kursi",     		"Brown stool",               2350,   2550},
    {"Kursi",     		"Red stool",                 2125,   2550},
    {"Kursi",     		"Tall wooden dining chair",  2124,   2550},
    {"Kursi",     		"Tall brown dining chair",   1739,   2550},
    {"Kursi",     		"Checkered dining chair",    2807,   2550},
    {"Kursi",     		"Plain office chair",        1671,   2550},
    {"Kursi",     		"Brown folding chair",       19996,  2550},
    {"Kursi",     		"Light brown chair",         19994,  2550},
    {"Kursi",     		"Black lounge chair",        1704,   1000},
    {"Kursi",     		"Beige lounge chair",        1705,   1000},
    {"Kursi",     		"Dark blue reclining chair", 1708,   1000},
    {"Kursi",     		"Brown corner chair",  		 11682,  1000},
    {"Kursi",     		"Old timer's lounge chair",  1711,   1000},
    {"Kursi",     		"Old timer's rocking chair", 1735,   1000},
    {"Kursi",     		"Two chairs and a table",    2571,   1000},
    {"Kursi",     		"Dark brown foot stool",     2293,   1000},
    {"Kursi",     		"Rocking chair",             11734,  2550},
    {"Kursi",     		"Plaid sofa",                1764,   7550},
    {"Kursi",     		"Long black sofa",           1723,   7550},
    {"Kursi",     		"Beige sofa",                1702,   7550},
    {"Kursi",     		"Brown couch",               1757,   7550},
    {"Kursi",     		"Old timer's sofa",          1728,   7550},
    {"Kursi",     		"Brown corner couch piece",  2292,   1000},
    {"Kursi",     		"White & grey couch",        1761,   7550},
    {"Kursi",     		"Patterned couch",           1760,   7550},
    {"Kursi",     		"Plaid couch",               1764,   7550},
    {"Kursi",     		"Dark blue couch",           1768,   7550},
    {"Kursi",     		"Wide brown couch",          2290,   7550},
    {"Kursi",     		"Green couch",               1766,   7550},
    {"Kursi",     		"Patterned armrest couch",   1763,   7550},
    {"Kursi",     		"Red couch",                 11717,  7550},
    {"Kursi",     		"Very wide beige couch",     1710,   11000},
    {"Kursi",     		"Ultra wide beige couch",    1709,   2000},
    {"Kursi",     			"Red and white couch",       1707,   7550},
    {"Poster/Bingkai",  	"Burger shot poster",        2641,   550},
    {"Poster/Bingkai",  	"Cluckin' bell poster",      2766,   550},
    {"Poster/Bingkai",  	"Wash wands poster",         2685,   550},
    {"Poster/Bingkai",  	"For lease poster",          11289,  550},
    {"Poster/Bingkai",  	"Monkey juice poster",       19328,  550},
    {"Poster/Bingkai",  	"Ring donuts poster",        2715,   550},
    {"Poster/Bingkai",  	"Battered ring posterr",     2716,   550},
	{"Poster/Bingkai",  	"Pizza poster",         	 2668,   550},
    {"Poster/Bingkai",  	"T-Shirt poster",            2729,   550},
    {"Poster/Bingkai",  	"Suburban poster",           2658,   550},
    {"Poster/Bingkai",  	"Zip poster",                2736,   550},
    {"Poster/Bingkai", 		"Binco poster",              2722,   550},
    {"Poster/Bingkai",  	"99c binco poster",          2719,   550},
    {"Poster/Bingkai", 		"Binco sale poster",         2721,   550},
    {"Poster/Bingkai",  	"Heat poster",               2661,   550},
    {"Poster/Bingkai",  	"Eris poster",               2655,   550},
    {"Poster/Bingkai",  	"Bobo poster",               2662,   550},
    {"Poster/Bingkai",  	"Base 5 poster",             2691,   550},
    {"Poster/Bingkai",  	"Base 5 cutout #1",        	 2693,   550},
    {"Poster/Bingkai",  	"Base 5 cutout #2",        	 2692,   550},
    {"Poster/Bingkai",  	"Long base 5 poster #1",   	 2695,   550},
    {"Poster/Bingkai",  	"Long base 5 poster #2",   	 2696, 	 550},
    {"Poster/Bingkai",  	"White prolaps poster",   	 2697,   550},
    {"Poster/Bingkai",  	"Black prolaps poster",   	 2656,   550},
    {"Poster/Bingkai",  	"San Fierro frame",       	 19175,  800},
    {"Poster/Bingkai",  	"Flint County frame",     	 19174,  800},
    {"Poster/Bingkai",  	"Gant Bridge frame",      	 19173,  800},
    {"Poster/Bingkai",  	"Los Santos frame",       	 19172,  800},
    {"Poster/Bingkai",  	"City View frame",    		 2289,   800},
    {"Poster/Bingkai",  	"Los Angeles frame",      	 2258,   800},
	{"Poster/Bingkai",  	"Wooden frame",           	 2288,   800},
	{"Poster/Bingkai",  	"Sail Boat frame",        	 2287,   800},
	{"Poster/Bingkai",  	"Ship frame",             	 2286,   800},
	{"Poster/Bingkai",  	"Water frame",            	 2285,   800},
	{"Poster/Bingkai",  	"Church frame",           	 2284,   800},
    {"Poster/Bingkai",  	"Rural frame",        		 2282,   800},
    {"Poster/Bingkai",  	"Sunset frame",				 2281,   800},
    {"Poster/Bingkai",  	"Coast frame",        		 2280,   800},
    {"Poster/Bingkai",  	"Mount chiliad frame",    	 2279,   800},
    {"Poster/Bingkai",  	"Cargo ship frame",       	 2278,   800},
    {"Poster/Bingkai",  	"Cat frame",          		 2277,   800},
    {"Poster/Bingkai",  	"Bridge frame",          	 2276,   800},
    {"Poster/Bingkai",  	"Fruit Bowl frame",       	 2275,   800},
    {"Poster/Bingkai",  	"Flower frame",          	 2274,   800},
    {"Poster/Bingkai",  	"Bouquet frame",          	 2273,   800},
    {"Poster/Bingkai",  	"Landscape frame",        	 2272,   800},
    {"Poster/Bingkai",  	"Paper frame",         		 2271,   800},
    {"Poster/Bingkai",  	"Leaves frame",         	 2270,   800},
    {"Poster/Bingkai",  	"Lake frame",         		 2269,   800},
    {"Poster/Bingkai",  	"Black cat frame",        	 2268,   800},
    {"Poster/Bingkai",  	"Cruise ship frame",      	 2267,   800},
    {"Poster/Bingkai",  	"Night downtown frame",		 2266,   800},
    {"Poster/Bingkai",  	"Dseert rocks frame",     	 2265,   800},
    {"Poster/Bingkai",  	"Beach frame",         		 2264,   800},
    {"Poster/Bingkai",  	"Dock frame",         		 2263,   800},
    {"Poster/Bingkai", 		 "Downtown frame",         	 2262,   800},
    {"Poster/Bingkai", 		 "Golden gate frame",      	 2261,   800},
    {"Poster/Bingkai", 		 "Old Boat frame",         	 2260,   800},
    {"Poster/Bingkai",  	"Bowling frame",          	 2259,   800},
    {"Poster/Bingkai", 		"Pattern frame",        	 2283,   800},
    {"Poster/Bingkai", 	 	"Squares frame",          	 2257,   800},
    {"Poster/Bingkai",  	"Palm trees frame",       	 2256,   800},
    {"Poster/Bingkai",  	"Erotic frame",         	 2255,   800},
    {"Poster/Bingkai",  	"Yellow car frame",       	 2254,   10},
    {"Penyimpanan",     	"Book shelf",                1742,   1000},
	{"Penyimpanan",     	"Wardrobe",         	     2307,   400},
	{"Penyimpanan",     	"Wooden crate",            	 1217,   1550},
	{"Penyimpanan",     	"Metal crate",               964,    1550},
	{"Penyimpanan",     	"Wide office cabinet",       2200,   1550},
	{"Penyimpanan",    	 	"Yellow cabinet",         	 1730,   1550},
	{"Penyimpanan",     	"Open gym locker",        	 11730,  2550},
	{"Penyimpanan",     	"Closed gym locker",      	 11729,  2550},
	{"Penyimpanan",     	"Toolbox",          		 19921,  1000},
	{"Penyimpanan",     	"Chest",                     19918,  800},
	{"Penyimpanan",     	"Dresser",                   2094,   2550},
	{"Penyimpanan",     	"Warehouse rack",         	 3761,   1550},
	{"Penyimpanan",     	"Barrel rack",           	 925,    2550},
	{"Penyimpanan",     	"Sex toy rack",          	 2581,   2550},
	{"Penyimpanan",     	"Sex magazine rack #1",      2578,   2550},
	{"Penyimpanan",     	"Sex magazine rack #2",      2579,   2550},
	{"Penyimpanan",     	"Rack with no shelves",      2509,   2550},
	{"Penyimpanan",     	"Rack with 3 shelves",       2482,   2550},
	{"Penyimpanan",     	"Rack with 4 shelves",       2475,   2550},
	{"Penyimpanan",     	"Small rack",			 	 2463,   2550},
	{"Penyimpanan",     	"Wide rack",              	 2462,   2550},
	{"Penyimpanan",     	"Dresser with drawers",      1743,   2550},
	{"Penyimpanan",     	"Wide dresser",              2087,   2550},
	{"Penyimpanan",     	"Tall dresser",              2088,   2550},
	{"Penyimpanan",     	"Brown dresser",             2089,   2550},
	{"Penyimpanan",     	"Single dresser",            2095,   2550},
	{"Penyimpanan",     	"White filing cabinet",   	 2197,   2550},
	{"Penyimpanan",     	"Green filing cabinet",   	 2610,   2550},
	{"Penyimpanan",     	"Dual filing cabinets",      2007,   2550},
	{"Penyimpanan",     	"Black shelf",          	 2078,   2550},
	{"Penyimpanan",     	"Brown shelf",               2204,   2550},
	{"Penyimpanan",     	"Tool shelf",                19899,  2550},
	{"Penyimpanan",    	 	"Tool cabinet",     		 19900,  2550},
	{"Penyimpanan",     	"Wall mounted shelf",        19940,  2550},
	{"Penyimpanan",     	"Clothes shelf",          	 2708,   2550},
	{"Penyimpanan",     	"Gun rack",         		 2046,   2550},
	{"Penyimpanan",     	"Shop shelf",             	 19640,  2550},
	{"Penyimpanan",     	"Blue office shelf",         2191,   2550},
	{"Penyimpanan",     	"Wooden office shelf",       2199,   2550},
	{"Penyimpanan",     	"Office book shelf",         2161,   2550},
	{"Penyimpanan",     	"Tall office cabinet",       2167,   800},
	{"Penyimpanan",     	"Wide office cabinet",       2163,   800},
	{"Tanaman",   			"Palm plant #1",          	 625,    800},
    {"Tanaman",   			"Palm plant #2",          	 626,    800},
    {"Tanaman",   			"Palm plant #3",          	 627,    800},
    {"Tanaman",   			"Palm plant #4",          	 628,  	 800},
    {"Tanaman",   			"Palm plant #5",          	 630,    800},
    {"Tanaman",   			"Palm plant #6",          	 631,    800},
    {"Tanaman",   			"Palm plant #7",          	 632,    800},
    {"Tanaman", 	  		"Palm plant #8",         	 633,    800},
    {"Tanaman",  			"Palm plant #9",         	 646,    800},
    {"Tanaman",	   			"Palm plant #10",            644,    800},
    {"Tanaman", 	  		"Palm plant #11",         	 2001,   800},
    {"Tanaman",  	 		"Palm plant #12",        	 2010,   800},
    {"Tanaman",   			"Palm plant #13",        	 2011,   1550},
    {"Tanaman",  	 		"Potted plant #1",           948,    1550},
    {"Tanaman",   			"Potted plant #2",           949,    1550},
    {"Tanaman",   			"Potted plant #3",           950,  	 1550},
    {"Tanaman",   			"Potted plant #4",           2194,   1550},
    {"Tanaman",  	 		"Potted plant #5",           2195,   1550},
    {"Tanaman",   			"Potted plant #6",           2203,   1550},
    {"Tanaman",   			"Potted plant #7",           2240,   1550},
    {"Tanaman",   			"Potted plant #8",           2241,   1550},
    {"Tanaman",   			"Potted plant #9",           2242, 	 1550},
    {"Tanaman",   			"Potted plant #10",          2244, 	 1550},
    {"Tanaman",   			"Potted plant #11",          2245,   1550},
    {"Tanaman",   			"Potted plant #12",          2246,   1550},
    {"Tanaman",   			"Potted plant #13",          2248,   1550},
    {"Tanaman",   			"Potted plant #14",          2252,   1550},
    {"Tanaman",   			"Potted plant #15",          2253,   1550},
    {"Tanaman",   			"Potted plant #16",          2811,   1550},
    {"Tanaman",  	 		"Wide plant",      			 638,    2550},
    {"Tanaman",  	 		"Single bush plant",         1361,   2550},
    {"Tanaman",  	 		"Wide bush plant",           1360,   2550},
    {"Tanaman",  			"Bush plant and bench",      1364,   1000},
    {"Tanaman",  	 		"Window plant #1",           3802,   200},
    {"Tanaman",  	 		"Window plant #2",           3810,   200},
    {"Sampah",  	        "Wastebin",                  11706,  550},
    {"Sampah",        	    "Blue trashcan on wheels",   1339,   550},
	{"Sampah", 		        "Blue trashcan",     		 1430,   550},
	{"Sampah",     	        "Trashcan with holes",       1359,   550},
	{"Sampah",        	    "Cluckin' bell trashcan", 	 2770,   550},
	{"Sampah",         	    "Burger shot trashcan",   	 2420,   550},
	{"Sampah",        	    "Round bagged trashcan",     1330,   550},
	{"Sampah",         	    "Round white trashcan",      1329,   550},
	{"Sampah",              "Metal trashcan",            1328, 	 550},
	{"Sampah",           	"Full dumpster",          	 1415,   550},
	{"Sampah",           	"Closed dumpster",           1227,   550},
	{"Sampah",           	"Bottle disposal unit",      1336,   550},
	{"Sampah",        	    "Blue dumpster",             1334,   550},
	{"Sampah",       	    "Red dumpster",              1333,   550},
	{"Sampah",       	    "Hippo trashcan",            1371,   550},
	{"Sampah",      	    "Poor trashcan",             1347,   550},
	{"Sampah",     		    "Cement trashcan",           1300,   550},
	{"Sampah",       	    "Trashcan filled with wood", 1442,   550},
	{"Sampah",       	    "Two pallets & trash",       1450,   550},
	{"Sampah",       	    "Single pallet",             1448,   550},
	{"Sampah",       	    "Garbage bag",               1265,   550},
	{"Sampah",       	    "Burger shot bag",           2663,   550},
	{"Sampah",      	    "Pile of boxes",             1440,   550},
    {"Sampah",     			"Cardboard box",             1221,   550},
    {"Sampah",              "Open pizza box",            2860,   550},
    {"Sampah",           	"Takeaway trash",         	 2866,   550},
    {"Sampah",           	"Burger shot trash",      	 2840,   550},
	{"Sampah",           	"Dirty dishes #1",      	 2812,   550},
    {"Sampah",           	"Dirty dishes #2",   		 2822,   550},
    {"Sampah",           	"Dirty dishes #3",      	 2829,   550},
    {"Sampah",           	"Dirty dishes #4",      	 2830,   550},
    {"Sampah",           	"Dirty dishes #5",      	 2831,   550},
    {"Sampah",           	"Dirty dishes #6",      	 2832,   550},
    {"Sampah",           	"Clean dishes #1",   		 2862,   550},
    {"Sampah",           	"Clean dishes #2",   		 2863,   550},
    {"Sampah",           	"Clean dishes #3",   		 2864,   550},
    {"Sampah",           	"Clean dishes #4",   		 2865,   550},
    {"Sampah",           	"Assorted trash #1",         2672,   550},
    {"Sampah",           	"Assorted trash #2",         2677,   550},
    {"Sampah",           	"Assorted trash #3",         2675,   550},
    {"Sampah",           	"Assorted trash #4",         2676,   550},
    {"Sampah",           	"Assorted trash #5",         2674,   550},
    {"Sampah",           	"Assorted trash #6",         2673,   550},
    {"Sampah",          	"Assorted trash #7",         2670,   550},
    {"Pintu & Gerbang",   	"Door with bars",            2930,   800},
    {"Pintu & Gerbang", 	"Petrol door",               2911,   800},
    {"Pintu & Gerbang", 	"Flat door",          		 3061,   800},
    {"Pintu & Gerbang", 	"Wardrobe door",       	     1567,   800},
    {"Pintu & Gerbang", 	"Green push door",        	 1492,   800},
    {"Pintu & Gerbang",	    "Red windowed door",       	 1493,   800},
    {"Pintu & Gerbang",     "Black wooden door",         1494,   800},
    {"Pintu & Gerbang",     "Brown windowed door",       3089,   800},
    {"Pintu & Gerbang",   "Wooden farm door",        	 1497,   800},
    {"Pintu & Gerbang",   "White wooden door",           1498,   800},
    {"Pintu & Gerbang",   "Warehouse door",       	 1499,   800},
    {"Pintu & Gerbang",   "Red door",        			 1504,   800},
    {"Pintu & Gerbang",   "Blue door",        		 1505,   800},
    {"Pintu & Gerbang",   "White door",        		 1506,   800},
    {"Pintu & Gerbang",   "Yellow door",        		 1507,   800},
    {"Pintu & Gerbang",   "Kitchen door",        		 1523,   800},
    {"Pintu & Gerbang",   "Motel door",        		 1535,   800},
    {"Pintu & Gerbang",   "Blue motel door",           2970,   800},
    {"Pintu & Gerbang",   "7/11 door",     			 1560,   800},
    {"Pintu & Gerbang",   "Barred door",          	 3061,   800},
    {"Pintu & Gerbang",   "Red motel door",            3029,   800},
    {"Pintu & Gerbang",   "Security door",       		 2949,   800},
    {"Pintu & Gerbang",   "Tall white door",           2948,   800},
    {"Pintu & Gerbang",   "Bank door",           		 2946,   800},
    {"Pintu & Gerbang",   "Ship door",     			 2944,   800},
    {"Pintu & Gerbang",   "Tower door",        		 977,    800},
    {"Pintu & Gerbang",   "Maintenance doors",         11714,  800},
    {"Pintu & Gerbang",   "Dual dffice door",          19176,  800},
    {"Pintu & Gerbang",   "Screen door #1",        	 1495,   800},
    {"Pintu & Gerbang",   "Screen door #2",        	 1500,   800},
    {"Pintu & Gerbang",   "Screen door #3",        	 1501,   800},
    {"Pintu & Gerbang",   "Shop door #1",        		 1532,   800},
    {"Pintu & Gerbang",   "Shop door #2",      		 1496,   800},
    {"Pintu & Gerbang",   "Shop door #3",        		 1533,   800},
    {"Pintu & Gerbang",   "Shop door #4",        		 1537,   800},
    {"Pintu & Gerbang",   "Shop door #5",        		 1538,   800},
    {"Pintu & Gerbang",   "Office door #1",          	 1566,   800},
    {"Pintu & Gerbang",   "Office door #2",         	 1569,   800},
    {"Pintu & Gerbang",   "Office door #3",        	 1536,   800},
    {"Pintu & Gerbang",   "Office door #4",        	 1557,   800},
    {"Pintu & Gerbang",   "Office door #5",        	 1556,   800},
    {"Pintu & Gerbang",   "Wooden push door #1",       1491,   800},
    {"Pintu & Gerbang",   "Wooden push door #2",       1502,   800},
    {"Pintu & Gerbang",   "Garage door #1",            8957,   800},
    {"Pintu & Gerbang",   "Garage door #2",            7891,   800},
    {"Pintu & Gerbang",   "Garage door #3",     	 	 3037,   800},
    {"Pintu & Gerbang",   "Garage door #4",            19861,  800},
    {"Pintu & Gerbang",   "Garage door #5",            19864,  800},
    {"Pintu & Gerbang",   "Plain metal bar gate",      19912,  1000},
    {"Pintu & Gerbang",   "Tall metal bar gate",       971,    1000},
    {"Pintu & Gerbang",   "Long metal bar gate",       975,    1000},
    {"Pintu & Gerbang",   "Los Santos Airport gate",   980,    1000},
    {"Pintu & Gerbang",   "Fenced gate",               985,    1000},
    {"Pintu & Gerbang",   "No parking gate",           19870,  1000},
    {"Pintu & Gerbang",   "Fenced gate on wheels",     988,    1000},
    {"Tembok",           "wall001",                   19353,  800},
    {"Tembok",           "wall002",                   19354,  800},
    {"Tembok",           "wall003",                   19355,  800},
    {"Tembok",           "wall004",                   19356,  800},
    {"Tembok",           "wall005",                   19357,  800},
    {"Tembok",           "wall006",                   19358,  800},
    {"Tembok",           "wall007",                   19359,  800},
    {"Tembok",           "wall008",                   19360,  800},
    {"Tembok",           "wall009",                   19361,  800},
    {"Tembok",           "wall010",                   19362,  800},
    {"Tembok",           "wall011",                   19363,  800},
    {"Tembok",           "wall012",                   19364,  800},
    {"Tembok",           "wall013",                   19365,  800},
    {"Tembok",           "wall014",                   19366,  800},
    {"Tembok",           "wall015",                   19367,  800},
    {"Tembok",           "wall016",                   19368,  800},
    {"Tembok",           "wall017",                   19369,  800},
    {"Tembok",           "wall018",                   19370,  800},
    {"Tembok",           "wall019",                   19371,  800},
    {"Tembok",           "wall020",                   19372,  800},
    {"Tembok",           "wall021",                   19373,  800},
    {"Tembok",           "wall022",                   19374,  800},
    {"Tembok",           "wall023",                   19375,  800},
    {"Tembok",           "wall024",                   19376,  800},
    {"Tembok",           "wall025",                   19377,  800},
    {"Tembok",           "wall026",                   19378,  800},
    {"Tembok",           "wall027",                   19379,  800},
    {"Tembok",           "wall028",                   19380,  800},
    {"Tembok",           "wall029",                   19381,  800},
    {"Tembok",           "wall030",                   19382,  800},
    {"Tembok",           "wall031",                   19383,  800},
    {"Tembok",           "wall032",                   19384,  800},
    {"Tembok",           "wall033",                   19385,  800},
    {"Tembok",           "wall034",                   19386,  800},
    {"Tembok",           "wall035",                   19387,  800},
    {"Tembok",           "wall036",                   19388,  800},
    {"Tembok",           "wall037",                   19389,  800},
    {"Tembok",           "wall038",                   19390,  800},
    {"Tembok",           "wall039",                   19391,  800},
    {"Tembok",           "wall040",                   19392,  800},
    {"Tembok",           "wall041",                   19393,  800},
    {"Tembok",           "wall042",                   19394,  800},
    {"Tembok",           "wall043",                   19395,  800},
    {"Tembok",           "wall044",                   19396,  800},
    {"Tembok",           "wall045",                   19397,  800},
    {"Tembok",           "wall046",                   19398,  800},
    {"Tembok",           "wall047",                   19399,  800},
    {"Tembok",           "wall048",                   19400,  800},
    {"Tembok",           "wall049",                   19401,  800},
    {"Tembok",           "wall050",                   19402,  800},
    {"Tembok",           "wall051",                   19403,  800},
    {"Tembok",           "wall052",                   19404,  800},
    {"Tembok",           "wall053",                   19405,  800},
    {"Tembok",           "wall054",                   19406,  800},
    {"Tembok",           "wall055",                   19407,  800},
    {"Tembok",           "wall056",                   19408,  800},
    {"Tembok",           "wall057",                   19409,  800},
    {"Tembok",           "wall058",                   19410,  800},
    {"Tembok",           "wall059",                   19411,  800},
    {"Tembok",           "wall060",                   19412,  800},
    {"Tembok",           "wall061",                   19413,  800},
    {"Tembok",           "wall062",                   19414,  800},
    {"Tembok",           "wall063",                   19415,  800},
    {"Tembok",           "wall064",                   19416,  800},
    {"Tembok",           "wall065",                   19417,  800},
    {"Tembok",           "wall066",                   19426,  800},
    {"Tembok",           "wall067",                   19427,  800},
    {"Tembok",           "wall068",                   19428,  800},
    {"Tembok",           "wall069",                   19429,  800},
    {"Tembok",           "wall070",                   19430,  800},
    {"Tembok",           "wall071",                   19431,  800},
    {"Tembok",           "wall072",                   19432,  800},
    {"Tembok",           "wall073",                   19433,  800},
    {"Tembok",           "wall074",                   19434,  800},
    {"Tembok",           "wall075",                   19435,  800},
    {"Tembok",           "wall076",                   19436,  800},
    {"Tembok",           "wall077",                   19437,  800},
    {"Tembok",           "wall078",                   19438,  800},
    {"Tembok",           "wall079",                   19439,  800},
    {"Tembok",           "wall080",                   19440,  800},
    {"Tembok",           "wall081",                   19441,  800},
    {"Tembok",           "wall082",                   19442,  800},
    {"Tembok",           "wall083",                   19443,  800},
    {"Tembok",           "wall084",                   19444,  800},
    {"Tembok",           "wall085",                   19445,  800},
    {"Tembok",           "wall086",                   19446,  800},
    {"Tembok",           "wall087",                   19447,  800},
    {"Tembok",           "wall088",                   19448,  800},
    {"Tembok",           "wall089",                   19449,  800},
    {"Tembok",           "wall090",                   19450,  800},
    {"Tembok",           "wall091",                   19451,  800},
    {"Tembok",           "wall092",                   19452,  800},
    {"Tembok",           "wall093",                   19453,  800},
    {"Tembok",           "wall094",                   19454,  800},
    {"Tembok",           "wall095",                   19455,  800},
    {"Tembok",           "wall096",                   19456,  800},
    {"Tembok",           "wall097",                   19457,  800},
    {"Tembok",           "wall098",                   19458,  800},
    {"Tembok",           "wall099",                   19459,  800},
    {"Tembok",           "wall100",                   19460,  800},
    {"Tembok",           "wall101",                   19461,  800},
    {"Tembok",           "wall102",                   19462,  800},
    {"Tembok",           "wall103",                   19463,  800},
    {"Tembok",           "wall104",                   19464,  800},
    {"Tembok",           "wall105",                   19465,  800},
    {"Dekorasi",           "Guard tower",               3279,   5000},
    {"Dekorasi",           "Tool board",                19815,  550},
    {"Dekorasi",           "Mailbox",                   19867,  550},
    {"Dekorasi",           "Single key",                11746,  550},
    {"Dekorasi",           "Oxygen cylinder",           19816,  550},
    {"Dekorasi",           "Cauldron",                  19527,  550},
    {"Dekorasi",           "Valve",                     2983,   550},
    {"Dekorasi",           "Writing board",             19805,  550},
    {"Dekorasi",           "Punching bag",              1985,   550},
    {"Dekorasi",           "Desk fan",           		 2192,   550},
    {"Dekorasi",           "Satellite dish",            3031,   550},
    {"Dekorasi",           "Shopping cart",             1349,   550},
    {"Dekorasi",           "Fireplace logs",			 19632,  550},
    {"Dekorasi",           "Telescope",                 2600,   550},
    {"Dekorasi",           "Ladder",                    1428,   550},
    {"Dekorasi",           "Plank",                     2937,   550},
    {"Dekorasi",           "Blue curtains",             2558,   550},
    {"Dekorasi",           "Old curtains",              14443,  550},
    {"Dekorasi",           "Blinds",                    18084,  550},
    {"Dekorasi",           "United states flag",        11245,  550},
    {"Dekorasi",           "Double US flag",            2614,   550},
    {"Dekorasi",           "Confederate flag",          2048,   550},
    {"Dekorasi",           "Basketball court",          946,    550},
    {"Dekorasi",           "Basketball",                2114,   550},
    {"Dekorasi",           "Fire exit sign",            11710,  550},
    {"Dekorasi",           "Fire extinguisher",         2690,   550},
    {"Dekorasi",           "Fire extinguisher panel",   11713,  550},
    {"Dekorasi",           "Fire alarm",                11713,  550},
    {"Dekorasi",           "Fire hydrant",              1211,   550},
	{"Dekorasi",           "Crack packet",            2891,   550},
    {"Dekorasi",           "Drug bundle",         		 1279,   550},
    {"Dekorasi",           "White package",           	 1575,   550},
    {"Dekorasi",           "Orange package",          	 1576,   550},
    {"Dekorasi",           "Yellow package",          	 1577, 	 550},
    {"Dekorasi",           "Green package",           	 1578, 	 550},
    {"Dekorasi",           "Blue package",            	 1579,   550},
    {"Dekorasi",           "Red package",             	 1580,   550},
    {"Dekorasi",           "Marijuana bundle",     	 2901,   550},
    {"Dekorasi",           "Marijuana plant",           3409,   550},
    {"Dekorasi",           "Ashtray",           		 1510, 	 550},
    {"Dekorasi",           "Ashtray with cigar",        1665,   550},
    {"Dekorasi",           "Pumpkin",                   19320,  550},
    {"Dekorasi",           "Christmas tree",            19076,  550},
    {"Dekorasi",           "Stage",         			 19608,  2550},
    {"Dekorasi",           "Gold record",          	 19617,  800},
    {"Dekorasi",           "Moose head",        		 1736,   8550},
    {"Dekorasi",           "Cow",                       19833,  1000},
    {"Dekorasi",           "Rocking horse",             11733,  550},
    {"Dekorasi",			"Deer",						 19315,  550},
    {"Dekorasi",           "Boot",                      11735,  550},
    {"Dekorasi",           "Old radiator",      		 1738,   550},
    {"Dekorasi",           "Radiator",                  11721,  550},
    {"Dekorasi",           "Round light",               11727,  550},
    {"Dekorasi",           "Mop & pail",          		 1778,   550},
    {"Dekorasi",           "Chambermaid",       		 1789,   550},
    {"Dekorasi",           "Bucket",            		 2713,   550},
    {"Dekorasi",           "Trolley",                   2994,   550},
    {"Dekorasi",           "Body bags",        		 16444,  550},
    {"Dekorasi",           "Beach ball",                1598, 	 550},
    {"Dekorasi",           "Blackboard",        		 3077,   550},
    {"Dekorasi",           "Dumbell",       			 3072,   550},
    {"Dekorasi",           "Sports bag",                11745,  550},
    {"Dekorasi",           "Portable toilet",           2984,   550},
    {"Dekorasi",   		"Round burger shot sign", 	 2643,   550},
    {"Dekorasi",           "Stretcher",          		 1997,   550},
    {"Dekorasi",           "Hospital bed",              2146,   550},
    {"Dekorasi",           "Work lamp",                 2196,   550},
    {"Dekorasi",           "Fire bell",       			 1613,   550},
    {"Dekorasi",           "Sword",                     19590,  550},
    {"Dekorasi",           "Wooden bat",                19914,  550},
    {"Dekorasi",           "Hand fan",                  19591,  550},
    {"Dekorasi",           "Shop basket",               19592,  550},
    {"Dekorasi",           "Safe door",                 19619,  550},
    {"Dekorasi",           "Safe enclosure",            19618,  550},
    {"Dekorasi",           "Bag of money",              1550,   550},
    {"Dekorasi",           "Oil can",                   19621,  550},
    {"Dekorasi",           "Wrench",                    19627,  550},
    {"Dekorasi",           "Engine",                    19917,  550},
    {"Dekorasi",           "Broom",                     19622,  550},
    {"Dekorasi",           "Briefcase",                 19624,  550},
    {"Dekorasi",           "Cigarette",                 19625,  550},
    {"Dekorasi",           "Fire wood",                 19632,  550},
    {"Dekorasi",           "Compacted trash",           19772,  550},
    {"Dekorasi",           "Medic kit",                 11738,  550},
    {"Dekorasi",           "Clip",                      19995,  550},
    {"Dekorasi",           "Dippo lighter",             19998,  550},
    {"Dekorasi",           "Briquettes",                19573,  550},
    {"Dekorasi",           "Meat Sack",                 2805,   550},
    {"Dekorasi",           "Small meat sack",           2803,   550},
    {"Dekorasi",           "Stack of magazines",        2855,   550},
    {"Dekorasi",           "Scattered magazines",       2852,   550},
    {"Dekorasi",           "Scattered books",           2854,   550},
    {"Dekorasi",           "Wooden stairs",             3361,   550},
    {"Dekorasi",           "Long concrete stairs",      14410,  550},
    {"Dekorasi",           "Short concrete stairs",     14416,  550},
    {"Dekorasi",           "Short stairs",              14877,  550},
    {"Dekorasi",           "Big window",      			 19325,  800},
    {"Dekorasi",           "Small window",           	 19466,  550},
    {"Dekorasi",           "Breakable window",       	 1649,   75},
    {"Dekorasi",           "Target #1",           		 2056,   550},
    {"Dekorasi",           "Target #2",           		 2055,   550},
    {"Dekorasi",           "Target #3",           		 2051,   550},
    {"Dekorasi",           "Target #4",           		 2050,   550},
    {"Dekorasi",           "Target #5",           		 2049,   550},
    {"Dekorasi",           "Clothes pile #1",     		 2819,   550},
    {"Dekorasi",           "Clothes pile #2",      	 2843,   550},
    {"Dekorasi",           "Clothes pile #3",      	 2844,   550},
    {"Dekorasi",           "Clothes pile #4",      	 2845,   550},
    {"Dekorasi",           "Clothes pile #5",      	 2846,   550},
   	{"Efek", 	 		"Smoke Flare",      	 	18728, 3000},
	{"Efek", 	 		"Puke",      	 		 	18722, 3000},
	{"Efek", 	 		"Molotov Fire",      	 	18701, 3000},
	{"Efek", 	 		"Coke Trail",      	 		18676, 3000},
	{"Efek", 	 		"Cam Flash (Once)",     	18670, 3000},
	{"Efek", 	 		"Flasher", 			 		345,   3000},
	{"Spesial",  		"Chemistry Dryer",      	3287,  1200},
	{"Spesial",  		"Centrifuge",      	 		19830, 31000},
	{"Spesial",  		"Mixer",      			 	19585, 21000},
	{"Spesial",  		"Reactor",      		 	2360,  2000},
	{"Spesial",  		"Dehydrater",      	 		2002,  900},
	{"Spesial",  		"Pickup Pump",      	 	1244,  6000},
	{"Spesial",  		"Pickup Pump (Small)",  	1008,  1000},
	{"Spesial",  		"Bike Pedal",      	 		2798,  1000},
	{"Spesial",  		"Long Exhaust",      	 	1114,  700},
	{"Graffiti", 		"Tag [GSF]", 				18659, 800},
	{"Graffiti", 		"Tag [SBF]", 				18660, 800},
	{"Graffiti", 		"Tag [VLA]", 				18661, 800},
	{"Graffiti", 		"Tag [KTB]", 				18662, 800},
	{"Graffiti", 		"Tag [SFR]", 				18663, 800},
	{"Graffiti", 		"Tag [TBD]", 				18664, 800},
	{"Graffiti", 		"Tag [LSV]", 				18665, 800},
	{"Graffiti", 		"Tag [FYB]", 				18666, 800},
	{"Graffiti", 		"Tag [RHB]", 				18667, 800},
	{"Campur",     		"Wine Glass",  		 		19818, 8550},
	{"Campur",     		"Cocktail Glass",       	19819, 8550},
	{"Campur",     		"Propbeer Glass",  	 		1666,  8550},
	{"Campur",     		"Big Cock",  		 	 	19823, 8550},
	{"Campur",     		"Red rum",  		     	19820, 8550},
	{"Campur",     		"Vodka",  		         	19821, 8550},
	{"Campur",     		"X.O",  		         	19824, 8550},
	{"Campur",    		"Damaged crate",  		 	924,   8550},
	{"Campur",     		"Top crate",  		     	1355,  8550},
	{"Campur",    	 	"Empty crate",  		 	19639, 8550},
	{"Campur",     		"Paper Messes",  		 	2674,  8550},
	{"Campur",     		"Fisinh Rod",  		 		18632, 600},
	{"Campur",     		"Rope1",  			 	 	19087, 800},
	{"Campur",     		"CJ_FLAG1",  			 	2047,  800},
	{"Campur",     		"kmb_packet",           	2891,  1000},
	{"Campur",     		"craigpackage",         	1279,  1000},
	{"Campur",     		"drug_white",           	1575,  1000},
	{"Campur",     		"drug_orange",          	1576,  1000},
	{"Campur",     		"drug_yellow",          	1577,  1000},
	{"Campur",    		"drug_green",           	1578,  1000},
	{"Campur",     		"drug_blue",            	1579,  1000},
	{"Campur",    	 	"drug_red",             	1580,  1000},
	{"Campur",     		"kmb_marijuana",        	2901,  2000},
	{"Campur",     		"grassplant",           	3409,  1000},
	{"Campur",     		"DYN_ASHTRY",           	1510,  1000},
	{"Campur",     		"propashtray1",         	1665,  1000},
	{"Campur",     		"WoodenStage1",         	19608, 2000},
	{"Campur",     		"DrumKit1",      			19609, 1000},
	{"Campur",     		"Microphone1",          	19610, 1000},
	{"Campur",     		"MicrophoneStand1",     	19611, 2000},
	{"Campur",     		"GuitarAmp1",           	19612, 1000},
	{"Campur",     		"GuitarAmp2",        	 	19613, 2000},
	{"Campur",     		"GuitarAmp3",        	 	19614, 2000},
	{"Campur",     		"GuitarAmp4",       	 	19615, 1000},
	{"Campur",     		"GuitarAmp5",       	 	19616, 1000},
	{"Campur",     		"GoldRecord1",          	19617, 1200},
	{"Campur",     		"CJ_Stags_head",        	1736,  2000},
	{"Campur",     		"CJ_Radiator_old",      	1738,  1000},
	{"Campur",     		"CJ_MOP_PAIL",          	1778,  1000},
	{"Campur",     		"CJ_chambermaid",       	1789,  2000},
	{"Campur",     		"cj_bucket",            	2713,  1000},
	{"Campur",     		"des_blackbags",        	16444, 2000},
	{"Campur",     		"nf_blackboard",        	3077,  2000},
	{"Campur",     		"kmb_dumbbell_L",       	3072,  1000},
	{"Campur",     		"kmb_dumbbell_R",       	3071,  1000},
	{"Campur",     		"portaloo",             	2984,  1200},
	{"Campur",     		"CJ_TARGET6",           	2056,  1000},
	{"Campur",     		"CJ_TARGET5",           	2055,  1000},
	{"Campur",     		"CJ_TARGET4",           	2051,  1000},
	{"Campur",     		"CJ_TARGET2",           	2050,  1000},
	{"Campur",     		"CJ_TARGET1",           	2049,  1000},
	{"Campur",     		"hos_trolley",          	1997,  1000},
	{"Campur",     		"shop_sec_cam",     	 	1886,  1000},
	{"Campur",     		"nt_firehose_01",       	1613,  1000},
	{"Campur",     		"lsmall_window01",      	19325, 2000},
	{"Campur",     		"window001",            	19466, 1200},
	{"Campur",     		"wglasssmash",          	1649,  1000},
	{"Campur",     		"Orange1",          	 	19574, 1000},
	{"Campur",     		"Apple1",     			 	19575, 1000},
	{"Campur",     		"Apple2",       		 	19576, 1000},
	{"Campur",     		"Tomato1",      		 	19577, 1000},
	{"Campur",     		"Banana1",              	19578, 1000},
	{"Campur",     		"gb_bedclothes01",      	2819,  800},
	{"Campur",     		"gb_bedclothes02",      	2843,  800},
	{"Campur",     		"gb_bedclothes03",      	2844,  800},
	{"Campur",     		"gb_bedclothes04",      	2845,  800},
	{"Campur",     		"gb_bedclothes05",      	2846,  800},
	{"Campur",     		"GB_platedirty01",      	2812,  800},
	{"Campur",     		"GB_kitchplatecln01",   	2822,  800},
	{"Campur",     		"GB_platedirty02",      	2829,  800},
	{"Campur",    	 	"GB_platedirty04",      	2830,  800},
	{"Campur",     		"GB_platedirty03",      	2831,  800},
	{"Campur",     		"GB_platedirty05",      	2832,  800},
	{"Campur",     		"GB_kitchplatecln02",   	2862,  800},
	{"Campur",     		"GB_kitchplatecln03",   	2863,  800},
	{"Campur",     		"GB_kitchplatecln04",   	2864,  800},
	{"Campur",     		"GB_kitchplatecln05",   	2865,  800},
	{"Campur",  	 		"Angel",      	 		 	3935,  5000},
	{"Campur",  	 		"Carter Statue",      	 	14467, 5000},
	{"Campur",  	 		"Broken Statue",      	 	2743,  5000},
	{"Campur",  	 		"Rocking Horse",      	 	11733, 5000},
	{"Campur",  	 		"Clothes Hanger",       	2373,  1000}
};

//

PurchaseFurniture(playerid, index)
{
    if(pData[playerid][pMoney] < furnitureArray[index][fPrice])
    {
        SCM(playerid, COLOR_SYNTAX, "Kamu tidak dapat membeli ini. Kamu tidak punya cukup uang untuk itu.");
    }
    else
    {
        new
            Float:x,
            Float:y,
	        Float:z,
    	    Float:a;

        if(pData[playerid][pEditType] == EDIT_FURNITURE_PREVIEW && IsValidDynamicObject(pData[playerid][pEditObject])) // Bug fix where if you did '/furniture buy' again while editing your object gets stuck. (12/28/2016)
        {
            DestroyDynamicObject(pData[playerid][pEditObject]);
            pData[playerid][pEditObject] = INVALID_OBJECT_ID;
		}

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

		pData[playerid][pEditType] = EDIT_FURNITURE_PREVIEW;
		pData[playerid][pEditObject] = CreateDynamicObject(furnitureArray[index][fModel], x + 2.0 * floatsin(-a, degrees), y + 2.0 * floatcos(-a, degrees), z + 1.0, 0.0, 0.0, ((19353 <= furnitureArray[index][fModel] <= 19417) || (19426 <= furnitureArray[index][fModel] <= 19465)) ? (a + 90.0) : (a), GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
        pData[playerid][pSelected] = index;

		//SM(playerid, COLOR_AQUA, "Kamu sekarang sedang melihat pratinjau "SVRCLR"%s{CCFFFF}. Objek ini membutuhkan biaya {00AA00}%s{CCFFFF} untuk membelinya.", furnitureArray[index][fName], FormatNumber(furnitureArray[index][fPrice]));
		//SM(playerid, COLOR_AQUA, "Gunakan kursormu untuk mengontrol antarmuka editor. Klik floppy disk untuk menyimpan perubahan.");
        EditDynamicObject(playerid, pData[playerid][pEditObject]);
	}
}

IsDoorObject(objectid)
{
	new
		modelid = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID);

	if((modelid) && !IsGateObject(objectid))
	{
		for(new i = 0; i < sizeof(furnitureArray); i ++)
		{
	    	if(!strcmp(furnitureArray[i][fCategory], "Pintu & Gerbang ") && furnitureArray[i][fModel] == modelid)
	    	{
		        return 1;
			}
		}
	}

	return 0;
}

HasFurniturePerms(playerid, houseid)
{
	return GetOwnedHouses(playerid, houseid) || pData[playerid][pFurniturePerms] == houseid;
}

GetHouseFurnitureCapacity(houseid)
{
	switch(hData[houseid][hLevel])
	{
	    case 0: return 50;
	    case 1: return 100;
	    case 2: return 150;
	    case 3: return 200;
	    case 4: return 250;
	    case 5: return 500;
	}

	return 0;
}

Streamer_GetExtraInt(objectid, type)
{
    new extra[11];

    if(Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, extra, sizeof(extra)))
    {
        return extra[type];
    }

    return 0;
}

RemoveFurniture(objectid)
{
    if(IsValidDynamicObject(objectid) && Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) == E_OBJECT_FURNITURE)
	{
 		new
	        id = Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID);

	    DeleteFurnitureObject(objectid);

        new query[374];
	    mysql_format(g_SQL, query, sizeof(query), "DELETE FROM furniture WHERE id = %i", id);
	    mysql_tquery(g_SQL, query);
	}
}

DeleteFurnitureObject(objectid)
{
	if(IsValidDynamicObject(objectid) && Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) == E_OBJECT_FURNITURE)
	{
    	new Text3D:textid = Text3D:Streamer_GetExtraInt(objectid, E_OBJECT_3DTEXT_ID);

        if(IsValidDynamic3DTextLabel(textid))
        {
            DestroyDynamic3DTextLabel(textid);
        }

        DestroyDynamicObject(objectid);
	}
}

RemoveAllFurniture(houseid)
{
    if(hData[houseid][hExists])
	{
	    for(new i = 0; i <= Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i ++)
	    {
	        if(IsValidDynamicObject(i) && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_FURNITURE && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == HouseInfo[houseid][hID])
	        {
             	DeleteFurnitureObject(i);
			}
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM furniture WHERE houseid = %i", HouseInfo[houseid][hID]);
		mysql_tquery(connectionID, queryBuffer);
	}
}

ReloadFurniture(objectid, labels)
{
	if(IsValidDynamicObject(objectid) && Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) == E_OBJECT_FURNITURE)
	{
	    new
	        id = Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID);

	    DeleteFurnitureObject(objectid);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM furniture WHERE id = %i", id);
	    mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LOAD_FURNITURE, labels);
	}
}
ReloadAllFurniture(houseid)
{
    if(HouseInfo[houseid][hExists])
	{
	    for(new i = 0, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= j; i ++)
	    {
	        if(IsValidDynamicObject(i) && Streamer_GetExtraInt(i, E_OBJECT_TYPE) == E_OBJECT_FURNITURE && Streamer_GetExtraInt(i, E_OBJECT_EXTRA_ID) == HouseInfo[houseid][hID])
	        {
             	DeleteFurnitureObject(i);
			}
		}

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM furniture WHERE houseid = %i", HouseInfo[houseid][hID]);
		mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_LOAD_FURNITURE, HouseInfo[houseid][hLabels]);
	}
}

//

forward OnPlayerLockFurnitureDoor(playerid, id);
public OnPlayerLockFurnitureDoor(playerid, id)
{
	new status = !cache_get_field_content_int(0, "door_locked");

	if(status) {
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "{C2A2DA}%s mengunci pintu.", GetRPName(playerid));
	} else {
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "{C2A2DA}%s membuka kunci pintu.", GetRPName(playerid));
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE furniture SET door_locked = %i WHERE id = %i", status, id);
	mysql_tquery(connectionID, queryBuffer);
}

forward OnPlayerUseFurnitureDoor(playerid, objectid, id);
public OnPlayerUseFurnitureDoor(playerid, objectid, id)
{
    if(cache_get_row_int(0, 1))
	{
	    SCM(playerid, COLOR_SYNTAX, "Pintu ini terkunci.");
	}
	else
	{
		new
			status = !cache_get_row_int(0, 0),
			Float:rx,
			Float:ry,
			Float:rz;

		GetDynamicObjectRot(objectid, rx, ry, rz);

		if(status) {
		    rz -= 90.0;
		} else {
			rz += 90.0;
		}

		SetDynamicObjectRot(objectid, rx, ry, rz);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE furniture SET rot_z = '%f', door_opened = %i WHERE id = %i", rz, status, id);
		mysql_tquery(connectionID, queryBuffer);

		if(status)
		    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "{C2A2DA}%s membuka pintu.", GetRPName(playerid));
		else
		    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "{C2A2DA}%s menutup pintu.", GetRPName(playerid));
	}
}

forward OnQueryFinished(threadid, extraid);
public OnQueryFinished(threadid, extraid)
{
	new rows = cache_get_row_count(connectionID);

	switch(threadid)
	{
		case THREAD_LOAD_FURNITURE:
		{
		    for(new i = 0; i < rows; i ++)
		    {
		        new objectid = CreateDynamicObject(cache_get_field_content_int(i, "modelid"), cache_get_field_content_float(i, "pos_x"), cache_get_field_content_float(i, "pos_y"), cache_get_field_content_float(i, "pos_z"), cache_get_field_content_float(i, "rot_x"), cache_get_field_content_float(i, "rot_y"), cache_get_field_content_float(i, "rot_z"), cache_get_field_content_int(i, "world"), cache_get_field_content_int(i, "interior"));

				Streamer_SetExtraInt(objectid, E_OBJECT_TYPE, E_OBJECT_FURNITURE);
				Streamer_SetExtraInt(objectid, E_OBJECT_INDEX_ID, cache_get_field_content_int(i, "id"));
				Streamer_SetExtraInt(objectid, E_OBJECT_EXTRA_ID, cache_get_field_content_int(i, "houseid"));

				if(extraid)
				{
				    new
				        string[48];

				    cache_get_field_content(i, "name", string);

					format(string, sizeof(string), "[%i] - %s", objectid, string);
					Streamer_SetExtraInt(objectid, E_OBJECT_3DTEXT_ID, _:CreateDynamic3DTextLabel(string, COLOR_GREY2, cache_get_field_content_float(i, "pos_x"), cache_get_field_content_float(i, "pos_y"), cache_get_field_content_float(i, "pos_z"), 10.0, .worldid = cache_get_field_content_int(i, "world"), .interiorid = cache_get_field_content_int(i, "interior")));
				}
			}
		}
		case THREAD_COUNT_FURNITURE:
		{
		    new houseid = GetInsideHouse(extraid);

		    if(cache_get_row_int(0, 0) >= GetHouseFurnitureCapacity(houseid))
		    {
		        SM(extraid, COLOR_SYNTAX, "Rumahmu hanya diperbolehkan sampai %i furnitur pada levelnya saat ini.", GetHouseFurnitureCapacity(houseid));
		    }
		    else
		    {
				ShowDialogToPlayer(extraid, DIALOG_BUYFURNITURE1);
			}
		}
		case THREAD_SELL_FURNITURE:
		{
		    if(cache_get_row_count(connectionID))
		    {
		        new name[32], price = percent(cache_get_field_content_int(0, "price"), 75);

		        cache_get_field_content(0, "name", name);
		        GivePlayerCash(extraid, price);

		        SM(extraid, COLOR_AQUA, "Kamu telah menjual "SVRCLR"%s{CCFFFF} dan menerima pengembalian dana sebesar 75 persen %s.", name, FormatNumber(price));
		        RemoveFurniture(pData[extraid][pSelected]);
			}
		}
		case THREAD_CLEAR_FURNITURE:
		{
		    if(!rows)
		    {
		        SCM(extraid, COLOR_SYNTAX, "Rumahmu tidak memiliki furnitur yang bisa dijual.");
		    }
		    else
		    {
		        new price, houseid = GetInsideHouse(extraid);

			    for(new i = 0; i < rows; i ++)
				{
				    price += percent(cache_get_field_content_int(i, "price"), 75);
				}

				RemoveAllFurniture(houseid);

				GivePlayerCash(extraid, price);
				SM(extraid, COLOR_AQUA, "Kamu telah menjual total %i item dan menerima %s kembali.", rows, FormatNumber(price));
			}
		}
	}
}


CMD:furniture(playerid, params[])
{
	new houseid = GetInsideHouse(playerid), option[10], param[32];

	if(houseid == -1 || !HasFurniturePerms(playerid, houseid))
	{
	    return SCM(playerid, COLOR_SYNTAX, "Kamu tidak berada di dalam rumahmu.");
	}
	if(sscanf(params, "s[10]S()[32]", option, param))
	{
	    SCM(playerid, COLOR_LIGHTBLUE, "[USAGE]:{ffffff} /furniture [pilihan]");
	    SCM(playerid, COLOR_WHITE, "Pilihan: Buy, Edit, Sell, Allow, Disallow, Labels");
	    return 1;
	}
	if(!strcmp(option, "buy", true))
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM furniture WHERE houseid = %i", HouseInfo[houseid][hID]);
	    mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_COUNT_FURNITURE, playerid);
	}
	else if(!strcmp(option, "edit", true))
	{
	    new objectid;

	    if(sscanf(param, "i", objectid))
	    {
	        return SCM(playerid, COLOR_LIGHTBLUE, "[USAGE]:{ffffff} '/furniture' [edit] [objectid]");
		}
		if(!IsValidDynamicObject(objectid) || Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) != E_OBJECT_FURNITURE)
		{
		    return SCM(playerid, COLOR_SYNTAX, "Objek tidak valid. Kamu dapat menemukan ID objek untuk furniturmu dengan mengaktifkan label. [/furniture labels]");
        }
        if(Streamer_GetExtraInt(objectid, E_OBJECT_EXTRA_ID) != HouseInfo[houseid][hID])
        {
            return SCM(playerid, COLOR_SYNTAX, "Objek tidak valid. Objek mebel ini tidak ada di dalam rumahmu.");
        }

        pData[playerid][pEditType] = EDIT_FURNITURE;
        pData[playerid][pEditObject] = objectid;
        pData[playerid][pFurnitureHouse] = houseid;

		EditDynamicObject(playerid, objectid);
        GameTextForPlayer(playerid, "~w~Editing Mode~n~~g~Klik disk untuk menyimpan~n~~r~Tekan ESC untuk membatalkan", 5000, 1);
	}
	else if(!strcmp(option, "sell", true))
	{
	    new objectid;

	    if(sscanf(param, "i", objectid))
	    {
	        return SCM(playerid, COLOR_LIGHTBLUE, "[USAGE]:{ffffff} /furniture [sell] [objectid] (75%% refund)");
		}
		if(!IsValidDynamicObject(objectid) || Streamer_GetExtraInt(objectid, E_OBJECT_TYPE) != E_OBJECT_FURNITURE)
		{
		    return SCM(playerid, COLOR_SYNTAX, "Objek tidak valid. Kamu dapat menemukan ID objek untuk furniturmu dengan mengaktifkan label. [/furniture labels]");
        }
        if(Streamer_GetExtraInt(objectid, E_OBJECT_EXTRA_ID) != HouseInfo[houseid][hID])
        {
            return SCM(playerid, COLOR_SYNTAX, "Objek tidak valid. Objek mebel ini tidak ada di dalam rumahmu.");
        }

        pData[playerid][pSelected] = objectid;

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT name, price FROM furniture WHERE id = %i", Streamer_GetExtraInt(objectid, E_OBJECT_INDEX_ID));
        mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_SELL_FURNITURE, playerid);
	}
	else if(!strcmp(option, "allow", true))
	{
	    new targetid;

	    if(sscanf(param, "u", targetid))
	    {
	        return SCM(playerid, COLOR_LIGHTBLUE, "[USAGE]:{ffffff} '/furniture' [allow] [playerid]");
		}
		if(!IsHouseOwner(playerid, houseid))
	    {
	        return SCM(playerid, COLOR_SYNTAX, "Ini hanya bisa dilakukan oleh pemilik rumah.");
		}
		if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
		{
		    return SCM(playerid, COLOR_SYNTAX, "Orang yang ditentukan terputus atau jauh darimu.");
		}
		if(targetid == playerid)
		{
		    return SCM(playerid, COLOR_SYNTAX, "Kamu tidak dapat menggunakan perintah ini pada dirimu sendiri.");
		}
		if(pData[targetid][pFurniturePerms] == houseid)
		{
		    return SCM(playerid, COLOR_SYNTAX, "kamu sudah mengizinkan pemain untuk mengakses furnitur kamu.");
		}

		pData[targetid][pFurniturePerms] = houseid;

		SM(targetid, COLOR_AQUA, "%s telah mengizinkanmu untuk mengakses furnitur rumah mereka.", GetRPName(playerid));
		SM(playerid, COLOR_AQUA, "Kamu telah mengizinkan %s untuk mengakses furnitur rumahmu.", GetRPName(targetid));
	}
	else if(!strcmp(option, "disallow", true))
	{
	    new targetid;

	    if(sscanf(param, "u", targetid))
	    {
	        return SCM(playerid, COLOR_LIGHTBLUE, "[USAGE]:{ffffff} '/furniture' [disallow] [playerid]");
		}
		if(!IsHouseOwner(playerid, houseid))
	    {
	        return SCM(playerid, COLOR_SYNTAX, "Ini hanya bisa dilakukan oleh pemilik rumah.");
		}
		if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
		{
		    return SCM(playerid, COLOR_SYNTAX, "Orang yang ditentukan terputus atau jauh darimu.");
		}
		if(targetid == playerid)
		{
		    return SCM(playerid, COLOR_SYNTAX, "Kamu tidak dapat menggunakan perintah ini pada dirimu sendiri.");
		}
		if(pData[targetid][pFurniturePerms] != houseid)
		{
		    return SCM(playerid, COLOR_SYNTAX, "Kamu belum mengizinkan pemain untuk mengakses furniturmu.");
		}

		pData[targetid][pFurniturePerms] = -1;

		SM(targetid, COLOR_AQUA, "%s telah menghapus akses ke furnitur rumahmu.", GetRPName(playerid));
		SM(playerid, COLOR_AQUA, "Kamu telah menghapus akses %s ke furnitur rumahmu .", GetRPName(targetid));
	}
	else if(!strcmp(option, "labels", true))
	{
	    if(!HouseInfo[houseid][hLabels])
	    {
	        HouseInfo[houseid][hLabels] = 1;
         	SCM(playerid, COLOR_AQUA, "Kamu sekarang akan melihat label muncul di atas semua furniturmu.");
	    }
	    else
	    {
	        HouseInfo[houseid][hLabels] = 0;
	        SCM(playerid, COLOR_AQUA, "Kamu tidak akan lagi melihat label muncul di atas furniturmu.");
	    }

	    ReloadAllFurniture(houseid);
	}


	return 1;
}

