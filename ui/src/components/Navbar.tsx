import React, { ReactComponentElement, useEffect, useState } from "react";
import { Link, useLocation } from "react-router-dom";

// Pages
import { NewAdvert } from "../components/NewAdvert";

// MUI 
import AppBar from "@mui/material/AppBar";
import Box from '@mui/material/Box';
import Tab from '@mui/material/Tab';
import Tabs from '@mui/material/Tabs';
import Typography from '@mui/material/Typography';
import { useTheme } from "@mui/material/styles";
import Fab from "@mui/material/Fab";

// Icons
import AddIcon from "@mui/icons-material/Add";
import ExploreOutlined from "@mui/icons-material/ExploreOutlined";

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

export const NavBar = ({api, tabPage}:{api: any, tabPage: ReactComponentElement<any>}) => {
    const [value, setValue] = useState(0);
    const [openNewAdvertDialog, setOpenNewAdvertDialog] = useState(false);
    const location = useLocation();
    
    const theme = useTheme();

    const handleChange = (event: React.SyntheticEvent, newValue: number) => {
        setValue(newValue);
    };

    return (
        <Box sx={{ width: '100%' }}>
          <AppBar position="fixed" sx={{
              display: "flex",
              justifyContent: "stretch",
          }}>
              <Tabs value={value} onChange={handleChange}
                  indicatorColor="secondary"
                  textColor="inherit"
                  variant="fullWidth"
                  aria-label="full width tabs example"
              >
                  <Tab component={Link} to={'/explore'} icon={<ExploreOutlined />} {...a11yProps(0)} />
                  <Tab component={Link} to={'/profile'} icon={<Sigil config={{...config}}/>} {...a11yProps(2)} />
              </Tabs>
          </AppBar>
          <Box marginTop={theme.spacing(4)}>
                {tabPage}
          </Box>
          
          { location.pathname === "/adverts" || location.pathname === "/profile" ?
            <Fab color='primary' sx={{position: 'fixed', right: theme.spacing(4), bottom: theme.spacing(3)}}
              onClick={() => setOpenNewAdvertDialog(true)}>
                <AddIcon />
            </Fab> : null
          }
          <NewAdvert
            open={openNewAdvertDialog} handleCloseDialog={() => setOpenNewAdvertDialog(false)}
            api={api}
          /> 
        </Box>
    )
}
