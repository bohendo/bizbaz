import React, { useEffect, useState, useReducer } from "react";

// Urbit
import Urbit from "@urbit/http-api";
import { Charges, ChargeUpdateInitial, scryCharges } from "@urbit/api";

// Components
import { NavBar } from "./components/Navbar";
import { NewListing } from "./pages/NewListing";

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
  const [openReviewDialog, setOpenReviewDialog] = useState(false);
  const [openListingDialog, setOpenListingDialog] = useState(false);

  const toggleTheme = () => {
    if (theme.palette.mode === "dark") {
      localStorage.setItem("theme", "light");
      setTheme(lightTheme);
    } else {
      localStorage.setItem("theme", "dark");
      setTheme(darkTheme);
    }
  };

  // const postReview = () => {
  //   api.poke( {
  //     app: 'bizbaz',
  //     mark: 'review-action',
  //     json: { 
  //       'post-review': { 
  //         review: {
  //           reviewee: "~nec",
  //           reviewer: `~${window.ship}`,
  //           what: "test review",
  //           when: 1630471524
  //         }
  //       }
  //     }
  //   } )
  // }

  const handleClickFab = () => {
    setOpenListingDialog(true);
  }

  return (
    <ThemeProvider theme={theme}>
        <CssBaseline />
        <NavBar />
        <NewListing
          open={openListingDialog} handleCloseDialog={() => setOpenListingDialog(false)}
          api={api}
        />
        <Fab color='primary'>
          <AddIcon onClick={() => { console.log(window.ship) 
          handleClickFab()
        }} />
        </Fab>
    </ThemeProvider>
  );
}

