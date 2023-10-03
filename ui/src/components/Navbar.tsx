import React, { ReactComponentElement, useState } from "react";
import { Link } from "react-router-dom";

// MUI 
import AppBar from "@mui/material/AppBar";
import Box from '@mui/material/Box';
import Tab from '@mui/material/Tab';
import Tabs from '@mui/material/Tabs';
import Typography from '@mui/material/Typography';
import { useTheme } from "@mui/material";

// Icons
import HomeIcon from "@mui/icons-material/Home";
import ExploreOutlined from "@mui/icons-material/ExploreOutlined";

import '@urbit/sigil-js'

const config = {
 point: '~talsyx-talsud', // or 'zod'
 size: 24,
 detail:'default',
 space:'none',
}

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
          {children}
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

export const NavBar = ({api, tabPage}
  :{api: any, tabPage: ReactComponentElement<any>}) => {
    const [value, setValue] = useState(0);
    // const [tab1View, setTab1View] = useState

    console.log(tabPage);
    const theme = useTheme();

    const handleChange = (event: React.SyntheticEvent, newValue: number) => {
        console.log(`Setting newValue: ${newValue}`)
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
                    <Tab component={Link} to={'/adverts'} icon={<ExploreOutlined />} {...a11yProps(0)} />
                    <Tab icon={<urbit-sigil {...config} />} {...a11yProps(2)} />
                </Tabs>
            </AppBar>
            <Box marginTop={theme.spacing(4)}>
                <TabPanel value={value} index={0} dir={theme.direction}>
                  {/* <Adverts api={api}/> */}
                  {tabPage}
                </TabPanel>
                <TabPanel value={value} index={1} dir={theme.direction}>
                  <Typography variant="h2">
                    Profile
                  </Typography>
                </TabPanel>
            </Box>
        </Box>
    )
}
