import React, { useEffect } from 'react';
import { TCommit, TIntent } from '../types';

// MUI
import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import CardHeader from '@mui/material/CardHeader';
import Button from '@mui/material/Button';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemText from '@mui/material/ListItemText';
import Paper from '@mui/material/Paper';
import Typography from '@mui/material/Typography';
import { IntentCard } from './IntentCard';

export const IntentList = ({ intents, doCommit }: {
    intents: Array<TIntent>;
    doCommit: (intent: Tintent) => void;
}) => {

  if (intents.length > 0) {
    return (
      <List>
        {intents.map((intent: TIntent, i) => {
          return (
            <ListItem key={i}>
              <IntentCard
                intent={intent}
                doCommit={doCommit}
              />
            </ListItem>
          )
        })}
      </List>
    )
  } else {
    return (
      <Card variant='outlined' sx={{ p: 2, mt: 2 }}>
        <CardHeader title={'No one has expressed interest in this advert yet'}/>
      </Card>
    )
  }

}
