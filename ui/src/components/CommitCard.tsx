import React, { useEffect } from "react";
import { TCommit, TIntent } from "../types";

// MUI
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import Card from '@mui/material/Card';
import CardActions from '@mui/material/CardActions';
import CardContent from '@mui/material/CardContent';
import CardHeader from '@mui/material/CardHeader';
import Grid from '@mui/material/Grid';
import Typography from '@mui/material/Typography';

// Components
import { ShipLink } from "./ShipLink"
import { AdvertLink } from './AdvertLink'

export const CommitCard = ({ commit, makeReview }: {
    commit: TCommit;
    makeReview: () => void;
}) => {
  const myShip = `~${window.ship}`
  const vendor = commit ? commit.vendor.ship : "..."
  const client = commit ? commit.body.client.ship : "..."
  const isVendor = myShip === vendor
  return (
    <Card variant="outlined" sx={{ p: 8, mx: 8, my: 2 }}>

      <CardHeader
        title={isVendor ? (
          <Typography variant='h5'>
            You have commited to transacting with <ShipLink ship={client}/>
          </Typography>
        ) : (
          <Typography variant='h5'>
            <ShipLink ship={vendor}/> has commited to transacting with you
          </Typography>
        )}
        subheader={`Proceed to complete the transaction, then leave your review`}
      />

      <CardContent sx={{ m: 0, py: 0 }}>
        <Grid container spacing={2}>
          <Grid item xs={6}>
            <Box sx={{ display: 'flex', justifyContent: 'left' }}>
              <Typography variant='body1'>
                <AdvertLink advert={commit.intent.advert}/>
              </Typography>
            </Box>
          </Grid>
          <Grid item xs={6}>
            <Box sx={{ display: 'flex', justifyContent: 'right' }}>
              <Typography variant='body1'>
                {new Date(commit.body.when * 1000).toLocaleString()}
              </Typography>
            </Box>
          </Grid>
        </Grid>
      </CardContent>

      <Box sx={{ display: 'flex', justifyContent: 'center', my: 1 }}>
        <CardActions>
          <Button
            variant="contained"
            disabled={!commit}
            onClick={makeReview}
          >
            Review
          </Button>
        </CardActions>
      </Box>


    </Card>
  )
}
