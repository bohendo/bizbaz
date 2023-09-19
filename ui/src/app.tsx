import React, { useEffect, useState } from 'react';
import Urbit from '@urbit/http-api';
import { Charges, ChargeUpdateInitial, scryCharges } from '@urbit/api';

import { darkTheme, lightTheme } from "./styles";
import { Hidden } from "@mui/material";

import { NavBar } from "./components/Navbar";

// Material UI
import { ThemeProvider } from "@mui/material/styles";
import CssBaseline from "@mui/material/CssBaseline";


const savedTheme = localStorage.getItem("theme") || "";

const api = new Urbit('', '', window.desk);
api.ship = window.ship;

export const App = () => {
  const [theme, setTheme] = useState(savedTheme === "dark" || savedTheme === "" ? darkTheme : lightTheme);
  const [apps, setApps] = useState<Charges>();

  const toggleTheme = () => {
    if (theme.palette.mode === "dark") {
      localStorage.setItem("theme", "light");
      setTheme(lightTheme);
    } else {
      localStorage.setItem("theme", "dark");
      setTheme(darkTheme);
    }
  };

  useEffect(() => {
    async function init() {
    }

    init();
  }, []);

  return (
    <ThemeProvider theme={theme}>
        <CssBaseline />
        <NavBar />
    </ThemeProvider>
  );
}

