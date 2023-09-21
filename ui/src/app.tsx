import React, { useEffect, useState } from "react";
import { useNavigate, Link } from "react-router-dom";

// Urbit
import Urbit from "@urbit/http-api";
import { Charges, ChargeUpdateInitial, scryCharges } from "@urbit/api";

// Components
import { NavBar } from "./components/Navbar";

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
  const [apps, setApps] = useState<Charges>();
  // const navigate = useNavigate();

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
        <Fab color='primary'>
          <AddIcon onClick={() => {
            console.log("Hello")
            // navigate("/create-listing")
          }} />
        </Fab>
    </ThemeProvider>
  );
}

