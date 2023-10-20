import { createTheme } from '@mui/material/styles';

const breakpoints = {
  values: {
    xs: 0,
    sm: 600,
    md: 960,
    lg: 1200,
    xl: 1920,
  },
};

export const darkTheme = createTheme({
  breakpoints,
  palette: {
    background: {
      default: "#141A1F",
      paper: "#101418",
    },
    primary: {
      main: "#7B91A7",
    },
    secondary: {
      main: "#fef0e3",
    },
    mode: "dark",
  },
});

export const lightTheme = createTheme({
  breakpoints,
  palette: {
    background: {
      default: "EFEFEF",
      paper: "#e2e2e2",
    },
    primary: {
      main: "#1e3761",
    },
    secondary: {
      main: "#e6e9ef",
    },
    mode: "light",
  },
});
