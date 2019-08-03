//Dal1980 v1.0 Hello-Megadrive
//August 2019 V1.0

fe.load_module("animate");
fe.load_module("conveyor");

class UserConfig {
     </ label="Logo", help="Choose the logo" options="megadrive,genesis,none" order=2 /> logo="megadrive";
}


local myConfig = fe.get_config();
fe.layout.width = 1280;
fe.layout.height = 1024;

//conveyor variables
local flx = fe.layout.width; 
local fly = fe.layout.height;
local flw = fe.layout.width;
local flh = fe.layout.height;

//background
local bg1 = fe.add_image("parts/background.png", 0, 0, 1280, 1024);

//logo
if(myConfig["logo"] == "megadrive") local logo = fe.add_image("parts/megadrive-logo.png", 28, 85, 360, 58 );
else if(myConfig["logo"] == "genesis") local logo = fe.add_image("parts/genesis-logo.png", 28, 85, 360, 83 );


//title label
local labelTitle = fe.add_text("TITLE:", 0, 605, 81, 24);
labelTitle.align = Align.Right;
labelTitle.style = Style.Bold;
labelTitle.style = Style.Italic;
//title value
local labelTitle = fe.add_text("[Title]", 81, 605, 381, 24);
labelTitle.align = Align.Left;
labelTitle.style = Style.Bold;
labelTitle.style = Style.Italic;

//year label
local labelTitle = fe.add_text("YEAR:", 0, 630, 81, 24);
labelTitle.align = Align.Right;
labelTitle.style = Style.Bold;
labelTitle.style = Style.Italic;
//year value
local labelTitle = fe.add_text("[Year]", 81, 630, 381, 24);
labelTitle.align = Align.Left;
labelTitle.style = Style.Bold;
labelTitle.style = Style.Italic;

//genre label
local labelTitle = fe.add_text("GENRE:", 0, 655, 96, 24);
labelTitle.align = Align.Right;
labelTitle.style = Style.Bold;
labelTitle.style = Style.Italic;
//genre value
local labelTitle = fe.add_text("[!simpleCat]", 96, 655, 381, 24);
labelTitle.align = Align.Left;
labelTitle.style = Style.Bold;
labelTitle.style = Style.Italic;

//game label
local labelTitle = fe.add_text("GAME:", 545, 665, 96, 24);
labelTitle.align = Align.Left;
labelTitle.style = Style.Bold;
labelTitle.style = Style.Italic;
//game number
local labelTitle = fe.add_text("[ListEntry] / [ListSize]", 630, 665, 300, 24);
labelTitle.align = Align.Left;
labelTitle.style = Style.Bold;
labelTitle.style = Style.Italic;

//game label
local labelTitle = fe.add_text("PLAYED x TIME MIN", 195, 930, 300, 24);
labelTitle.align = Align.Left;
labelTitle.style = Style.Bold;
labelTitle.style = Style.Italic;
//game number
local labelTitle = fe.add_text("[PlayedCount] x [PlayedTime]", 195, 955, 300, 24);
labelTitle.align = Align.Left;
labelTitle.style = Style.Bold;
labelTitle.style = Style.Italic;

//external assets
local snapBox = fe.add_artwork("snap", 912, 322, 320, 240);
local logoBox = fe.add_artwork("logo", 912, 64, 320, 177);
local logoBox = fe.add_artwork("box", 420, 18, 439, 618);
local mascot = fe.add_image("parts/sonic.png", 104, 225, 230, 364);
local controller = fe.add_image("parts/controller.png", 13, 915, 163, 97);

//favourites
local favHolder = fe.add_image("parts/favourite-off.png", 440, 899, 400, 118);

//getFavs returns the image needed to represent the state of the favourite
function getFavs(index_offset) {
    if(fe.game_info( Info.Favourite, 0 ) == "1") return "parts/favourite-on.png";
    else return  "parts/favourite-off.png";
}

// wheel
local wheel_x = [  -999, -800, -500, -300, -118, 188, 497, 806, 1111, 1940, 1940, ];
local wheel_y = [   702,  702,  702,  702, 702, 702, 702,  702,  702,  702,  702, ];
local wheel_w = [   288,  288,  288,  288, 288, 288, 288,  288,  288,  288,  288, ];
local wheel_h = [   191,  191,  191,  191, 191, 191, 191,  191,  191,  191,  191, ];
local wheel_a = [   255,  255,  255,  255, 255, 255, 255,  255,  255,  255,  255, ];
local wheel_r = [   0,    0,    0,    0,   0,   0,   0,    0,    0,    0,    0, ];

local num_arts = 10;

class WheelEntry extends ConveyorSlot {
     
     constructor() {
          base.constructor( ::fe.add_artwork("cart"));
     }

     function on_progress( progress, var ) {
          local p = progress / 0.1;
          local slot = p.tointeger();
          p -= slot;
          slot++;

          if ( slot <= 0 ) slot=0;
          if ( slot >= 9 ) slot=9;

          if(m_obj.file_name == ""){
               m_obj.file_name = "parts/no_image.png";
          }
          m_obj.x = wheel_x[slot] + p * ( wheel_x[slot+1] - wheel_x[slot] );
          m_obj.y = wheel_y[slot] + p * ( wheel_y[slot+1] - wheel_y[slot] );
          m_obj.width = wheel_w[slot] + p * ( wheel_w[slot+1] - wheel_w[slot] );
          m_obj.height = wheel_h[slot] + p * ( wheel_h[slot+1] - wheel_h[slot] );
          m_obj.rotation = wheel_r[slot] + p * ( wheel_r[slot+1] - wheel_r[slot] );
          m_obj.alpha = wheel_a[slot] + p * ( wheel_a[slot+1] - wheel_a[slot] );
          m_obj.preserve_aspect_ratio = true;
          //if() m_obj.rotation = 45 + p * ( wheel_a[slot+1] - wheel_a[slot] );
     }
};

local wheel_entries = [];
for ( local i=0; i<num_arts/2; i++ )
wheel_entries.push( WheelEntry() );

local remaining = num_arts - wheel_entries.len();

// we do it this way so that the last wheelentry created is the middle 
// one showing the current selection (putting it at the top of the draw order)
for ( local i=0; i<remaining; i++ )
wheel_entries.insert( num_arts/2, WheelEntry() );

local conveyor = Conveyor();
conveyor.set_slots( wheel_entries );
conveyor.transition_ms = 55;

function simpleCat( ioffset ) {
  local m = fe.game_info(Info.Category, ioffset);
  local temp = split( m, " / " );
  if(temp.len() > 0) return temp[0];
  else return "";
}

fe.add_transition_callback( "update_my_list" );
function update_my_list( ttype, var, ttime ) {
    favHolder.file_name = getFavs(0);
    if(ttype == Transition.StartLayout){
        favHolder.file_name = getFavs(0);
    }
    else if(ttype == Transition.EndNavigation){
        favHolder.file_name = getFavs(0);
    } 
    return false;
}

//we put this here so that it covers our conveyor cart images
local consoleFront = fe.add_image("parts/console.png", 716, 716, 564, 308 );

