import React, { useEffect, useState, useReducer } from "react";
import { Outlet } from "react-router-dom";

// Components
import { NavBar } from "./components/Navbar";

// MUI 
import CssBaseline from "@mui/material/CssBaseline";
import { ThemeProvider } from "@mui/material/styles";
import { darkTheme, lightTheme } from "./styles";

const savedTheme = localStorage.getItem("theme") || "";

export const App = ({ api }: { api: any }) => {
  const [theme, setTheme] = useState(savedTheme === "dark" || savedTheme === "" ? darkTheme : lightTheme);

  const toggleTheme = () => {
    if (theme.palette.mode === "dark") {
      localStorage.setItem("theme", "light");
      setTheme(lightTheme);
    } else {
      localStorage.setItem("theme", "dark");
      setTheme(darkTheme);
    }
  };

  return (
    <ThemeProvider theme={theme}>
        <CssBaseline />
        <NavBar api={api} tabPage={<Outlet />}/>
    </ThemeProvider>
  );
}
