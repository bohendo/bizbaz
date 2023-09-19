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
    primary: {
      main: "#90caf9",
    },
    secondary: {
      main: "#ce93d8",
    },
    mode: "dark",
  },
});

export const lightTheme = createTheme({
  breakpoints,
  palette: {
    primary: {
      main: "#90caf9",
    },
    secondary: {
      main: "#ce93d8",
    },
    mode: "light",
  },
});
