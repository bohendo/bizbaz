import React, { useEffect, useState } from "react";
import { Box, styled, useTheme } from "@mui/material";
import { Link } from "react-router-dom";

// types
import { TListing } from "../types";

// MUI
import Card from "@mui/material/Card";
import CardActionArea from "@mui/material/CardActionArea";
import CardContent from "@mui/material/CardContent";
import Chip from "@mui/material/Chip";
import Typography from '@mui/material/Typography';
import Masonry from "@mui/lab/Masonry";
import Paper from "@mui/material/Paper";

import '@urbit/sigil-js'

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
      api.subscribe( { app: "bizbaz", path: '/listings', event: handleUpdate } )
    }
    init();
  }, []);

  if(listings.length == 0) return (
    <Typography>
      Loading
    </Typography>
  )

  const config = {
  point: '~talsyx-talsud', // or 'zod'
  size: 24,
  detail:'default',
  space:'none',
  }
  return (
    <Box>
      <Typography variant="h2">
        Listings
      </Typography>
      <Masonry columns={3} spacing={2}>
        {listings.map((listing: TListing, index: number) => {
          // TODO set itemHeight based on cover image
          const itemHeight = listing.description.length < 60 ? 200 : 260; 
          const descriptionCutOff = 60; 
          return (
            <Card key={index} sx={{ marginTop: theme.spacing(1) , height: itemHeight, width: 100 }}>
              <CardActionArea disableRipple
                sx={{ width: "100%", alignItems: "center" }}
                component={Link} to={'listing-id'/*`/${listing.id}`*/}>
                <urbit-sigil point={listing.who} size={60} detail='default' space='large'/>

                <CardContent
                  sx={{
                    backgroundColor: (theme) => theme.palette.mode === "light"
                      ? "rgba(256, 256, 256, 0.90)"
                      : "rgba(66,  66,  66,  0.90)",
                    opacity: "0.99",
                    height: "420px",
                  }}>
                    <Typography variant="caption" display="block">
                      {listing.who}
                    </Typography>
                    <Typography variant="caption" display="block">
                      {listing.tags.map((tag, index) => (
                        `${tag} `
                      ))}
                    </Typography>
                    <Typography variant="body2">
                      TODO: Add listing title in sur
                    </Typography>
                    <Typography variant="caption" marginTop={theme.spacing(1)}>
                      {listing.description.substring(0, descriptionCutOff)}
                    </Typography>
                </CardContent>
              </CardActionArea>
            </Card>
          )
        })}
      </Masonry>
    </Box>
  )
}

