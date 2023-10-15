import React, { useEffect } from "react";
import { TCommit, TIntent } from "../types";

// MUI
import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import CardHeader from '@mui/material/CardHeader';
import CardActions from '@mui/material/CardActions';
import Button from '@mui/material/Button';
import Typography from '@mui/material/Typography';

const myShip = `~${window.ship}`

export const CommitCard = ({ commit, doReview }: {
    commit: TCommit;
    doReview: () => void;
}) => {
  const vendor = commit ? commit.vendor.ship : "..."
  const client = commit ? commit.body.client.ship : "..."
  const isVendor = myShip === vendor
  return (
    <Card variant="outlined" sx={{ p: 2 }}>

      <CardHeader
        title={
          `${isVendor ? "You have" : `${vendor} has`} commited to transacting with ${isVendor ? client : "you"}`
        }
        subheader={`Proceed to complete the transaction, then leave your review`}
      />

      <Box sx={{ display: 'flex', justifyContent: 'center', marginBottom: 2 }}>
        <Button
          variant="contained"
          disabled={!commit}
          onClick={doReview}
        >
          Review
        </Button>
      </Box>

    </Card>
  )
}
