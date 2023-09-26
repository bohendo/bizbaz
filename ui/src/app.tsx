import React, { useEffect, useState, useReducer } from "react";
// import { useNavigate, Link } from "react-router-dom";

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

import TextField from '@mui/material/TextField';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import DialogTitle from '@mui/material/DialogTitle';

// Icons
import AddIcon from "@mui/icons-material/Add";


const savedTheme = localStorage.getItem("theme") || "";

const api = new Urbit('', '', window.desk);
api.ship = window.ship;

export const App = () => {
  const [theme, setTheme] = useState(savedTheme === "dark" || savedTheme === "" ? darkTheme : lightTheme);
  const [apps, setApps] = useState<Charges>();
  const [openReviewDialog, setOpenReviewDialog] = useState(false);
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

  const postListing = () => {
    api.poke( {
      app: 'bizbaz',
      mark: 'listing-action',
      json: { 
        create: { 
          listing: {
            who: `~${window.ship}`,
            tags: ["tag1", "tag2"],
            description: "test listing",
            when: 1630471524
          }
        }
      }
    } )

  }

  const postReview = () => {
    api.poke( {
      app: 'bizbaz',
      mark: 'review-action',
      json: { 
        'post-review': { 
          review: {
            reviewee: "~nec",
            reviewer: `~${window.ship}`,
            what: "test review",
            when: 1630471524
          }
        }
      }
    } )
  }

  const handleClickFab = () => {
    console.log("Setting dialog to true")
    setOpenReviewDialog(true);
  }

  const handleCloseDialog = () => {
    setOpenReviewDialog(false);
  }

  return (
    <ThemeProvider theme={theme}>
        <CssBaseline />
        <NavBar />
        <Dialog open={openReviewDialog} onClose={handleCloseDialog}>
          <DialogTitle> Review </DialogTitle>
            <DialogContent>
               <DialogContentText>
                  Add you review
               </DialogContentText>
            </DialogContent>
        </Dialog>
        <Fab color='primary'>
          <AddIcon onClick={() => { console.log(window.ship) 
          handleClickFab()
          postListing()
          // postReview()
        }} />
        </Fab>
        
    </ThemeProvider>
  );
}

