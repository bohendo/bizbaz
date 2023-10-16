import React, { useEffect } from 'react';

// MUI
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import Card from '@mui/material/Card';
import CardActions from '@mui/material/CardActions';
import CardContent from '@mui/material/CardContent';
import CardHeader from '@mui/material/CardHeader';
import Grid from '@mui/material/Grid';
import IconButton from '@mui/material/IconButton';
import Typography from '@mui/material/Typography';

// Icons
import BackHandIcon from '@mui/icons-material/BackHand';
import CommitIcon from '@mui/icons-material/Commit';

import { TIntent } from '../types';

// Components
import { ShipLink } from './ShipLink'
import { AdvertLink } from './AdvertLink'

export const IntentCard = ({intent, doCommit}: {
    intent: TIntent | undefined;
    doCommit: (intent: TIntent) => void;
}) => {
  const myShip = `~${window.ship}`
  const vendor = intent ? intent?.body?.vendor?.ship : '...'
  const client = intent ? intent?.client?.ship : '...'
  const isVendor = myShip === vendor
  return (
    <Card variant='outlined' sx={{ p: 2, mt: 2 }}>

      <CardHeader
        sx={{ m: 0 }}
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

      <CardContent sx={{ m: 0, py: 0 }}>
        <Grid container spacing={2}>
          <Grid item xs={6}>
            <Box sx={{ display: 'flex', justifyContent: 'left' }}>
              <Typography variant='body1'>
                <AdvertLink advert={intent.body.advert}/>
              </Typography>
            </Box>
          </Grid>
          <Grid item xs={6}>
            <Box sx={{ display: 'flex', justifyContent: 'right' }}>
              <Typography variant='body1'>
                {new Date(intent.body.when * 1000).toLocaleString()}
              </Typography>
            </Box>
          </Grid>
        </Grid>
      </CardContent>

      {isVendor ? (
        <CardActions>
          <Button onClick={() => doCommit(intent)}>
            Commit
          </Button>
        </CardActions>
      ) : null}

    </Card>
  )
}
