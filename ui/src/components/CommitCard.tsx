import React, { useEffect } from "react";
import { TCommit, TIntent } from "../types";

// MUI
import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import CardHeader from '@mui/material/CardHeader';
import CardActions from '@mui/material/CardActions';
import Button from '@mui/material/Button';
import Typography from '@mui/material/Typography';

export const CommitCard = ({ commit, isVendor, doReview }: {
    commit: TCommit;
    vendor: boolean;
    doReview: () => void;
}) => {
  console.log(`Rendering commit card for commit:`, commit)
  return (
    <Card variant="outlined" sx={{ p: 2, mx: 6 }}>

      <CardHeader
          title={`${commit.vendor.ship} has commited to transacting with ${commit.body.client.ship}`}
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
