import React, { useEffect } from "react";
import { TCommit, TIntent } from "../types";

// MUI
import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import CardHeader from '@mui/material/CardHeader';
import CardActions from '@mui/material/CardActions';
import Button from '@mui/material/Button';
import Typography from '@mui/material/Typography';

// Components
import { ShipLink } from "./ShipLink"

export const CommitCard = ({ commit, makeReview }: {
    commit: TCommit;
    makeReview: () => void;
}) => {
  const myShip = `~${window.ship}`
  const vendor = commit ? commit.vendor.ship : "..."
  const client = commit ? commit.body.client.ship : "..."
  const isVendor = myShip === vendor
  return (
    <Card variant="outlined" sx={{ p: 2 }}>

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

      <Box sx={{ display: 'flex', justifyContent: 'center', marginBottom: 2 }}>
        <Button
          variant="contained"
          disabled={!commit}
          onClick={makeReview}
        >
          Review
        </Button>
      </Box>

    </Card>
  )
}
