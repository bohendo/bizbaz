import React, { ReactComponentElement, useEffect, useState } from 'react';
import { Link , useLocation } from 'react-router-dom';

// Pages
import { NewAdvert } from '../components/NewAdvert';

// MUI 
import AppBar from '@mui/material/AppBar';
import IconButton from '@mui/material/IconButton';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import { useTheme } from '@mui/material/styles';
import Fab from '@mui/material/Fab';

// Icons
import AddIcon from '@mui/icons-material/Add';
import HomeIcon from '@mui/icons-material/Home';
import LightIcon from '@mui/icons-material/BrightnessHigh';
import DarkIcon from '@mui/icons-material/Brightness4';

import { Sigil } from './Sigil'

const config = {
 point: window.ship,
 size: 24,
 detail:'default',
 space:'none',
}

function a11yProps(index: number) {
  return {
    id: `tab-${index}`,
    'aria-controls': `tabpanel-${index}`,
  };
}

export const NavBar = ({api, toggleTheme}:{api: any, toggleTheme: () => void}) => {
    const [value, setValue] = useState(0);
    const [openNewAdvertDialog, setOpenNewAdvertDialog] = useState(false);
    const location = useLocation();
    
    const theme = useTheme();

    const handleChange = (event: React.SyntheticEvent, newValue: number) => {
        setValue(newValue);
    };

    return (<>
      <AppBar position="fixed" sx={{
          display: "flex",
          justifyContent: "stretch",
      }}>
        <Toolbar>
          <IconButton component={Link} to={'/explore'}>
            <HomeIcon />
          </IconButton>
          <Typography sx={{ flexGrow: 1, ml: theme.spacing(4)}}>
            {location.pathname}
          </Typography>
          <IconButton sx={{mr: 1}} onClick={toggleTheme}>
            {theme.palette.mode === 'dark' ? <LightIcon /> : <DarkIcon />}
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
      <NewAdvert
        open={openNewAdvertDialog} handleCloseDialog={() => setOpenNewAdvertDialog(false)}
        api={api}
      /> 
    </>)
}
