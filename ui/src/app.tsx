import React, { useEffect, useState, useReducer } from "react";

// Urbit
import Urbit from "@urbit/http-api";

// Components
import { NavBar } from "./components/Navbar";
import { NewAdvert } from "./pages/NewAdvert";

// MUI 
import CssBaseline from "@mui/material/CssBaseline";
import Fab from "@mui/material/Fab";
import { ThemeProvider } from "@mui/material/styles";
import { darkTheme, lightTheme } from "./styles";

// Icons
import AddIcon from "@mui/icons-material/Add";


const savedTheme = localStorage.getItem("theme") || "";

const api = new Urbit('', '', window.desk);
api.ship = window.ship;

export const App = () => {
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
        <NavBar api={api}/>
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

