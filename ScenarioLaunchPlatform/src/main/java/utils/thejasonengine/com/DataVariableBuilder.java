package utils.thejasonengine.com;

import java.util.Random;

public class DataVariableBuilder 
{
	
	private static final Random RANDOM = new Random();

    private static final String[] FIRST_NAMES = {
    		"James","Mary","Oliver","Isla","Liam","Emma","Noah","Ava","Lucas","Mia",
            "Elijah","Sophia","Mason","Charlotte","Logan","Amelia","Ethan","Harper",
            "Jacob","Evelyn","Michael","Abigail","Benjamin","Emily","Daniel","Ella",
            "Henry","Elizabeth","Jackson","Chloe","Sebastian","Grace","Aiden","Victoria",
            "Matthew","Lily","Samuel","Hannah","David","Aria","Joseph","Scarlett",
            "Carter","Zoey","Owen","Penelope","Wyatt","Lillian","John","Riley",
            "Gabriel","Natalie","Isaac","Audrey","Anthony","Nora","Jayden","Hazel",
            "Dylan","Aurora","Leo","Addison","Lincoln","Ellie","Christopher","Stella",
            "Joshua","Paisley","Andrew","Brooklyn","Grayson","Anna","Caleb","Leah",
            "Ryan","Sarah","Nathan","Allison","Christian","Claire","Hunter","Samantha",
            "Jonathan","Julia","Thomas","Skylar","Aaron","Alice","Charles","Madeline",
            "Isaiah","Sophie","Adam","Lucy","Julian","Ruby","Connor","Ariana","Zachary","Kennedy"
    };

    private static final String[] SURNAMES = {
    		"Smith","Johnson","Williams","Brown","Jones","Garcia","Miller","Davis","Rodriguez","Martinez",
            "Hernandez","Lopez","Gonzalez","Wilson","Anderson","Thomas","Taylor","Moore","Jackson","Martin",
            "Lee","Perez","Thompson","White","Harris","Sanchez","Clark","Ramirez","Lewis","Robinson",
            "Walker","Young","Allen","King","Wright","Scott","Torres","Nguyen","Hill","Flores",
            "Green","Adams","Nelson","Baker","Hall","Rivera","Campbell","Mitchell","Carter","Roberts",
            "Gomez","Phillips","Evans","Turner","Diaz","Parker","Cruz","Edwards","Collins","Reyes",
            "Stewart","Morris","Morales","Murphy","Cook","Rogers","Gutierrez","Ortiz","Morgan","Cooper",
            "Peterson","Bailey","Reed","Kelly","Howard","Ramos","Kim","Cox","Ward","Richardson",
            "Watson","Brooks","Chavez","Wood","James","Bennett","Gray","Mendoza","Ruiz","Hughes",
            "Price","Alvarez","Castillo","Sanders","Patel","Myers","Long","Ross","Foster","Jimenez"
    };

    private static final String[] STREET_NAMES = {
    		"Oak Avenue","Maple Street","Pine Road","Cedar Lane","Elm Drive","Cherry Boulevard","Willow Way","Ash Terrace","Hawthorn Close","Birch Crescent",
            "Spruce Court","Magnolia Place","Poplar Avenue","Sycamore Street","Chestnut Road","Walnut Lane","Beech Drive","Alder Boulevard","Dogwood Way","Cypress Terrace",
            "Redwood Circle","Juniper Trail","Laurel Street","Olive Avenue","Palmetto Road","Cottonwood Lane","Sequoia Drive","Hickory Boulevard","Larch Way","Hazel Court",
            "Fir Circle","Plane Place","Aspen Grove","Myrtle Street","Ironwood Avenue","Acacia Road","Bay Tree Lane","Holly Drive","Locust Boulevard","Linden Way",
            "Plane Tree Terrace","Alderney Close","Gardenia Court","Blossom Place","Clover Street","Daffodil Lane","Daisy Drive","Primrose Avenue","Rosewood Road","Violet Way",
            "Tulip Terrace","Orchid Trail","Ivy Court","Jasmine Circle","Lilac Place","Marigold Street","Poppy Lane","Sunflower Drive","Bluebell Boulevard","Buttercup Way",
            "Heather Terrace","Bramble Close","Foxglove Court","Honeysuckle Place","Fern Street","Moss Lane","Pebble Drive","Brookside Avenue","Meadow Road","Riverbank Lane",
            "Lakeside Drive","Hillcrest Boulevard","Valley View Way","Ridge Terrace","Glen Court","Forest Place","Woodland Street","Parkside Lane","Greenfield Drive","Highland Avenue",
            "Summit Road","Stonegate Lane","Rockwell Drive","Cliffside Boulevard","Clearwater Way","Harbor Terrace","Seaview Lane","Bayside Drive","Westwood Avenue","Eastgate Road",
            "Northfield Lane","Southridge Drive","Spring Street","Summer Lane","Autumn Drive","Winter Avenue","Morningstar Road","Evening Way","Sunset Boulevard","Horizon Terrace"
    };

    private static final String[] ADDRESS_LINE2_TEMPLATES = {
    		"Apt %s","Apartment %s","Apartment #%s","Apartment No. %s","Suite %s","Suite #%s","Suite No. %s","Unit %s","Unit #%s","Unit No. %s",
            "Floor %s","Flr %s","Floor #%s","Room %s","Room #%s","Rm %s","Rm. #%s","Building %s","Bldg %s","Bldg. %s",
            "Block %s","Blk %s","Lot %s","Lvl %s","Level %s","Piso %s","Dept %s","Dept. %s","Ofc %s","Office %s",
            "Office #%s","Penthouse %s","PH %s","Basement %s","Bsmt %s","Floor B%s","Wing %s","Tower %s","Twr %s","Building #%s",
            "Module %s","Mod %s","Section %s","Sec %s","Annex %s","Annex #%s","Annexe %s","Annexe #%s","Villa %s","House %s",
            "Chalet %s","Flat %s","Flat #%s","Flat No. %s","Maisonette %s","Room No. %s","Quarters %s","Qtrs %s","Hangar %s","Hngr %s",
            "Shed %s","Workshop %s","Works %s","Warehouse %s","Whse %s","Shop %s","Stall %s","Bay %s","Pad %s","Pad #%s",
            "Platform %s","Pltfm %s","Dock %s","Pier %s","Slip %s","Deck %s","Cabin %s","Cabin #%s","Cottage %s","Farm %s",
            "Barn %s","Loft %s","Suite Level %s","Unit Level %s","Penthouse #%s","Suite Floor %s","Unit Floor %s","Apartment Floor %s","Apartment Level %s","Unit Level %s",
            "Office Level %s","Office Floor %s","Level #%s","Tower Floor %s","Tower Level %s","Penthouse Floor %s","Penthouse Level %s","Building Level %s","Block Level %s","Complex %s"
    };
    
    private static final String[] COUNTRIES = {
            "Afghanistan","Albania","Algeria","Andorra","Angola","Argentina","Armenia","Australia","Austria","Azerbaijan",
            "Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bhutan","Bolivia",
            "Bosnia and Herzegovina","Botswana","Brazil","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada",
            "Cape Verde","Central African Republic","Chad","Chile","China","Colombia","Comoros","Costa Rica","Croatia","Cuba",
            "Cyprus","Czech Republic","Democratic Republic of the Congo","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt","El Salvador",
            "Equatorial Guinea","Eritrea","Estonia","Eswatini","Ethiopia","Fiji","Finland","France","Gabon","Gambia",
            "Georgia","Germany","Ghana","Greece","Grenada","Guatemala","Guinea","Guinea‑Bissau","Guyana","Haiti",
            "Honduras","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Israel","Italy",
            "Jamaica","Japan","Jordan","Kazakhstan","Kenya","Kiribati","Kuwait","Kyrgyzstan","Laos","Latvia",
            "Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Madagascar","Malawi","Malaysia"
        };
    
    private static final String[] PHONE_FORMATS = { "US","UK","AU","IE","DE","FR","IN","BR","CA","ZA" };
    private static final String[] POSTCODE_FORMATS = { "US","CA","UK","DE","FR","AU","NL","NZ","IE","IN" };


    // Prevent instantiation
    private DataVariableBuilder() {}

    public static String randomFirstName() {
        return pick(FIRST_NAMES);
    }

    public static String randomSurname() {
        return pick(SURNAMES);
    }

    public static String randomAddressLine1() {
        int houseNumber = RANDOM.nextInt(299) + 1; // 1 to 299
        String street = pick(STREET_NAMES);
        return houseNumber + " " + street;
    }

    public static String randomAddressLine2() {
        String template = pick(ADDRESS_LINE2_TEMPLATES);
        String value;
        if (RANDOM.nextBoolean()) {
            value = String.valueOf(RANDOM.nextInt(400) + 1); // numeric
        } else {
            value = String.valueOf((char) ('A' + RANDOM.nextInt(26))); // A-Z
        }
        return String.format(template, value);
    }

    private static String pick(String[] pool) 
    {
        return pool[RANDOM.nextInt(pool.length)];
    }

}
