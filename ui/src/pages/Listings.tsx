import React, { useEffect, useState } from "react";
import { styled, useTheme } from "@mui/material";

// Urbit
import Urbit from "@urbit/http-api";
import { Charges, ChargeUpdateInitial, scryCharges } from "@urbit/api";

import Typography from '@mui/material/Typography';

const api = new Urbit('', '', window.desk);
api.ship = window.ship;

export const Listings = () => {
  const theme = useTheme();

  const [listings, setListings] = useState([]);

  const postListing = () => {
    api.poke( {
      app: 'bizbaz',
      mark: 'listing-action',
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

  const handleUpdate = ( upd: any) => {
    if ( 'init' in upd ) {
      setListings(upd.listings)      
    }
  }

  useEffect(() => {
    async function init() {
      api.subscribe( { app: "bizbaz", path: '/review', event: handleUpdate } )
    }
    init();
  }, []);

  return (
    <Typography variant="p">
      Listings
    </Typography>
  )
}

