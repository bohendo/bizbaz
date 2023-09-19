import React, { useState } from "react";
// import SwipeableViews from 'react-swipeable-views';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import Typography from '@mui/material/Typography';
import Box from '@mui/material/Box';

import { styled, useTheme } from "@mui/material";
import AppBar from "@mui/material/AppBar";
import HomeIcon from "@mui/icons-material/Home";
import { AccountCircle, ExploreOutlined } from "@mui/icons-material";

interface TabPanelProps {
  children?: React.ReactNode;
  dir?: string;
  index: number;
  value: number;
}

function TabPanel(props: TabPanelProps) {
  const { children, value, index, ...other } = props;

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`full-width-tabpanel-${index}`}
      aria-labelledby={`full-width-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box sx={{ p: 3 }}>
          <Typography>{children}</Typography>
        </Box>
      )}
    </div>
  );
}


function a11yProps(index: number) {
  return {
    id: `tab-${index}`,
    'aria-controls': `tabpanel-${index}`,
  };
}

export const NavBar = () => {
    const [value, setValue] = useState(0);
    const theme = useTheme();

    const handleChange = (event: React.SyntheticEvent, newValue: number) => {
        console.log(`Setting newValue: ${newValue}`)
        setValue(newValue);
    };

    const handleChangeIndex = (index: number) => {
        setValue(index);
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
                    <Tab icon={<HomeIcon />} {...a11yProps(0)} />
                    <Tab icon={<ExploreOutlined />} {...a11yProps(1)} />
                    <Tab icon={<AccountCircle />} {...a11yProps(2)} />
                </Tabs>
            </AppBar>
            <Box marginTop={theme.spacing(4)}>
                <TabPanel value={value} index={0} dir={theme.direction}>
                Item One
                </TabPanel>
                <TabPanel value={value} index={1} dir={theme.direction}>
                Item Two
                </TabPanel>
                <TabPanel value={value} index={2} dir={theme.direction}>
                Item Three
                </TabPanel>
            </Box>
        </Box>
    )
}

/*

            <SwipeableViews
                axis={theme.direction === 'rtl' ? 'x-reverse' : 'x'}
                index={value}
                onChangeIndex={handleChangeIndex}
            >
            </SwipeableViews>
            */