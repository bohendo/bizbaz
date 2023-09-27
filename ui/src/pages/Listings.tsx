import React, { useEffect, useState } from "react";
import { Box, styled, useTheme } from "@mui/material";

// types
import { Listing } from "../types";

// MUI
import Typography from '@mui/material/Typography';
import Masonry from "@mui/lab/Masonry";
import Paper from "@mui/material/Paper";

const Item = styled(Paper)(({ theme }) => ({
  padding: theme.spacing(3),
  textAlign: 'center',
}))

export const Listings = ({
  api
}: { api: any }) => {
  const theme = useTheme();
  const [listings, setListings] = useState([]);


  const handleUpdate = ( upd: any) => {
    console.log(upd)
    if ( 'listings' in upd ) {
      console.log(upd);
      setListings(upd.listings)      
    }
  }

  useEffect(() => {
    async function init() {
      api.subscribe( { app: "bizbaz", path: '/reviews', event: handleUpdate } )
    }
    init();
  }, []);

  if(listings.length == 0) return (
    <Typography>
      Loading
    </Typography>
  )
  return (
    <Box>
      <Typography variant="h2">
        Listings
      </Typography>
      <Masonry columns={3} spacing={3}>
        {listings.map((listing: Listing, index: number) => (
          <Item key={index} sx={{ marginTop: theme.spacing(3) , height: 150 }}>
            <Typography variant="body2">

              Description: {listing.description}
            </Typography>
          </Item>
        ))}
      </Masonry>
    </Box>
  )
}

