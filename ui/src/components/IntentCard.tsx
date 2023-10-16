import React, { useEffect } from "react";

// MUI
import Card from '@mui/material/Card';
import CardHeader from '@mui/material/CardHeader';
import CardActions from '@mui/material/CardActions';
import { TIntent } from "../types";
import Button from '@mui/material/Button';
import IconButton from '@mui/material/IconButton';
import Typography from '@mui/material/Typography';

// Icons
import BackHandIcon from '@mui/icons-material/BackHand';
import CommitIcon from '@mui/icons-material/Commit';

// Components
import { ShipLink } from "./ShipLink"

export const IntentCard = ({intent, doCommit}: {
    intent: TIntent | undefined;
    doCommit: () => void;
}) => {
  const myShip = `~${window.ship}`
  const vendor = intent ? intent?.body?.vendor?.ship : "..."
  const client = intent ? intent?.client?.ship : "..."
  const isVendor = myShip === vendor
  return (
    <Card variant="outlined" sx={{ p: 2, mt: 2 }}>

      <CardHeader
        title={isVendor ? (
          <Typography variant='h5'>
            <ShipLink ship={client}/> has shown interest in this advert
          </Typography>
        ) : (
          <Typography variant='h5'>
            <ShipLink ship={vendor}/> has been notified of your interest in the advert
          </Typography>
        )}
        subheader={`Wait to complete the transaction until the vendor commits`}
      />

      {(vendor === myShip) ? (
        <CardActions>
          <Button onClick={() => doCommit(intent)}>
            Commit
          </Button>
        </CardActions>
      ) : null}

    </Card>
  )
}
