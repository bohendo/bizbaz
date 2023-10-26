import React, { useState } from 'react';
import { Link , useLocation } from 'react-router-dom';

// Pages
import { AdvertEditor } from '../components/AdvertEditor';

// MUI 
import AppBar from '@mui/material/AppBar';
import IconButton from '@mui/material/IconButton';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import { useTheme } from '@mui/material/styles';
import Fab from '@mui/material/Fab';

// Icons
import AddIcon from '@mui/icons-material/Add';
import DarkIcon from '@mui/icons-material/Brightness4';
import HomeIcon from '@mui/icons-material/Home';
import LightIcon from '@mui/icons-material/BrightnessHigh';
import SyncIcon from '@mui/icons-material/Sync';

import { Sigil } from './Sigil'

const config = {
 point: window.ship,
 size: 24,
 detail:'default',
 space:'none',
}

export const NavBar = ({api, toggleTheme}:{api: any, toggleTheme: () => void}) => {
    const [openNewAdvertDialog, setOpenNewAdvertDialog] = useState(false);
    const location = useLocation();
    
    const theme = useTheme();

    const handleSync = () => {
      console.log("Syncing");
      api.poke({
        app: 'bizbaz',
        mark: 'sync',
        json: {}
      });
    };

    return (<>
      <AppBar color='primary' position="fixed" sx={{
          display: "flex",
          justifyContent: "stretch",
      }}>
        <Toolbar>
          <IconButton component={Link} to={'/'}>
            <HomeIcon color='secondary' />
          </IconButton>
          <Typography sx={{ flexGrow: 1, ml: theme.spacing(4)}}>
            {location.pathname}
          </Typography>
          <IconButton sx={{mr: 1}} onClick={handleSync}>
            <SyncIcon />
          </IconButton>
          <IconButton sx={{mr: 1}} onClick={toggleTheme}>
            {theme.palette.mode === 'dark' ? <LightIcon color='secondary' /> : <DarkIcon color='secondary' />}
          </IconButton>
          <IconButton component={Link} to={`/profile/~${window.ship}`} sx={{mr: 1}}>
            <Sigil config={{...config}}/>
          </IconButton>

        </Toolbar>
      </AppBar>
          
      { location.pathname === "/advert" ? null :
        <Fab color='primary' sx={{position: 'fixed', right: theme.spacing(4), bottom: theme.spacing(3)}}
          onClick={() => setOpenNewAdvertDialog(true)}>
            <AddIcon />
        </Fab>
      }
      <AdvertEditor
        open={openNewAdvertDialog} handleCloseDialog={() => setOpenNewAdvertDialog(false)}
        api={api}
      /> 
    </>)
}
