import React, { useEffect, useState, useReducer } from "react";
import { Outlet } from "react-router-dom";

// Components
import { NavBar } from "./components/Navbar";
import { NewAdvert } from "./pages/NewAdvert";
import { Advert } from "./pages/Advert";

// MUI 
import CssBaseline from "@mui/material/CssBaseline";
import Fab from "@mui/material/Fab";
import { ThemeProvider } from "@mui/material/styles";
import { darkTheme, lightTheme } from "./styles";

// Icons
import AddIcon from "@mui/icons-material/Add";


const savedTheme = localStorage.getItem("theme") || "";

export const App = ({ api }: { api: any }) => {
  const [theme, setTheme] = useState(savedTheme === "dark" || savedTheme === "" ? darkTheme : lightTheme);
  const [openReviewDialog, setOpenReviewDialog] = useState(false);
  const [openAdvertDialog, setOpenAdvertDialog] = useState(false);

  const toggleTheme = () => {
    if (theme.palette.mode === "dark") {
      localStorage.setItem("theme", "light");
      setTheme(lightTheme);
    } else {
      localStorage.setItem("theme", "dark");
      setTheme(darkTheme);
    }
  };

  const handleClickFab = () => {
    setOpenAdvertDialog(true);
  }

  return (
    <ThemeProvider theme={theme}>
        <CssBaseline />
        <NavBar api={api} tabPage={<Outlet />}/>
        <NewAdvert
          open={openAdvertDialog} handleCloseDialog={() => setOpenAdvertDialog(false)}
          api={api}
        />
        <Fab color='primary' sx={{position: 'fixed', right: theme.spacing(4), bottom: theme.spacing(3)}} onClick={() => { console.log(window.ship); handleClickFab() }} >
          <AddIcon />
        </Fab>
    </ThemeProvider>
  );
}
