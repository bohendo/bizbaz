import React, { useContext, useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';

// MUI
import Backdrop from '@mui/material/Backdrop';
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import CircularProgress from '@mui/material/CircularProgress';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import Grid from '@mui/material/Grid';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import Fab from '@mui/material/Fab'
import Paper from "@mui/material/Paper";
import SpeedDial from "@mui/material/SpeedDial";
import SpeedDialAction from "@mui/material/SpeedDialAction";
import Stack from '@mui/material/Stack';
import Typography from '@mui/material/Typography';
import { useTheme } from "@mui/material/styles"

import { BizbazContext } from "../BizbazContext"

import { Commit, Intent, Review, Vote } from "../types";

// Icons
import DeleteIcon from '@mui/icons-material/Delete';
import EditIcon from '@mui/icons-material/Edit';
import ExpandLessIcon from '@mui/icons-material/ExpandLess';
import MessageIcon from '@mui/icons-material/Message';

// Components
import { Votes } from '../components/Votes';
import { IntentCard } from '../components/IntentCard';
import { CommitCard } from "../components/CommitCard";
import { ReviewCard } from "../components/ReviewCard";
import { AdvertEditor } from "../components/AdvertEditor";
import { ReviewEditor } from "../components/ReviewEditor";
import { ShipLink } from "../components/ShipLink";
import { Markdown } from "../components/Markdown";

export const Advert = ({ api }: { api: any }) => {
  const bizbaz = useContext(BizbazContext);
  const theme = useTheme();
  const { hash } = useParams();

  const [reviewCommit, setReviewCommit] = useState<Commit | undefined>(undefined);
  const [openNewAdvertDialog, setOpenNewAdvertDialog] = useState(false);
  const [openNewReviewDialog, setOpenNewReviewDialog] = useState(false);
  const [openBackdrop, setOpenBackdrop] = useState(false);
  const [openDeleteConfirmation, setOpenDeleteConfirmation] = useState(false);
  const [openEditReview, setOpenEditReview] = useState(false);
  const [imgError, setImgError] = useState(false);

  const myShip = `~${window.ship}`

  const { adverts, votes, intents, commits, reviews } = bizbaz;

  // Calculate some dynamic values from our bizbaz state
  const advert = adverts.find(a => a.hash === hash);
  const vendor = advert?.vendor?.ship;
  const advIntents = intents.filter(i => i.body.advert === hash);
  const advCommits = commits.filter(c => c.intent.advert === hash);
  const advReviews = reviews.filter(r => r.commit.intent.advert === hash);
  const vndReviews = reviews
    .filter(r => r.commit.vendor.ship === vendor)
    .filter(r => !advReviews.some(ar => ar.hash === r.hash))
    .filter(r => r.reviewer.ship !== vendor);

  const vote = (choice: string) => {
    console.log(choice);
    api.poke({
      app: 'bizbaz',
      mark: 'vote-action',
      json: { 
        'vote': { 
          advert: hash,
          choice: choice
        }
      }
    })
  }

  const deleteAd = (adHash: string) => {
    api.poke({
      app: 'bizbaz',
      mark: 'advert-action',
      json: { 
        'delete': { 
          hash: hash,
        }
      }
    })
  }

  const doIntent = () => {
      api.poke({
        app: 'bizbaz',
        mark: 'review-action',
        json: { 
          'intent': { 
            advert: hash
          }
        }
      })
  }

  const doCommit = (intent: Intent) => {
      if (!intent) {
          console.log(`No intent exists to commit to`)
          return
      }
      console.log(`Committing to intent`, intent)
      api.poke({
        app: 'bizbaz',
        mark: 'review-action',
        json: { 
          'commit': { intent: intent.hash }
        }
      })
  }

  const makeReview = (commit: Commit) => {
    setReviewCommit(commit)
    setOpenNewReviewDialog(true)
  }

  if (advert === undefined) {
    // TODO: create error 404 not found page
    return <Box sx={{ mt: theme.spacing(10) }}> This advert does not exist </Box>
  } else if (advert.body) {
    return (
      <Box sx={{width: "100%", mt: theme.spacing(10), minHeight: '100vh' }}>
        <Paper variant="outlined" sx={{ p: 8, mx: 8, mt: 4, mb: 2 }}>
          <Grid container direction="column" spacing={2}>
            <Grid item xs>
              {advert.body.cover && !imgError ? 
                <img src={advert.body.cover}
                  style={{
                    borderBottomLeftRadius: "0px",
                    borderBottomRightRadius: "0px",
                    borderTopLeftRadius: "4px",
                    borderTopRightRadius: "4px",
                    display: "block",
                    margin: "0 auto 16px auto",
                    maxWidth: "auto",
                    maxHeight: "400px",
                  }}
                  onError={() => setImgError(true)}
                /> : null}
            </Grid>
            <Grid item xs container spacing={2}>
              <Grid item xs={1}>
                <Votes votes={votes.filter((v: Vote) => v.body.advert === hash)}
                  vote={vote} disabled={myShip === advert.vendor.ship} />
              </Grid>
              <Grid item xs container direction="column" spacing={2}>
                <Grid item xs>
                  <Typography variant="caption" display="block">
                    Posted by: <ShipLink ship={advert.vendor.ship} />
                  </Typography>
                  <Typography variant="caption">
                    {(new Date(advert.body.when)).toLocaleString()}
                  </Typography>
                </Grid>
                <Grid item xs>
                  <Typography variant="h2">
                    {advert.body.title}
                  </Typography>
                  <Typography variant="h5">
                    Tags: {advert.body.tags?.join(", ")}
                  </Typography>
                  <Markdown content={advert.body.description} />
                </Grid>
              </Grid>
            </Grid>
          </Grid>

          {(myShip !== advert.vendor.ship) ? (
            <Stack direction="row" sx={{ justifyContent: "center", marginTop: 8 }} spacing={2}>
              <Button
                variant="contained"
                onClick={doIntent}
                disabled={!!advIntents.find(i => i.client.ship === myShip) || !!advCommits.find(c => c.body.client.ship === myShip)}
              >
                Express Intent
              </Button>
              <Button
                variant="contained"
                onClick={() => {
                  window.open(`${window.location.origin}/apps/talk/dm/${advert.vendor.ship}`,
                  '_blank');
                }}
                startIcon={<MessageIcon />}
              >
               Message Vendor 
              </Button>
            </Stack>
          ) : null}
        </Paper>

        {advIntents.length > 0 ? 
          <List sx={{px: 0}}>
            {advIntents.map((intent: Intent, i) => (
              <ListItem key={i} sx={{px: 0}}>
                <IntentCard
                  intent={intent}
                  doCommit={doCommit}
                />
              </ListItem>
            ))}
          </List> : null
        }

        {advCommits.length > 0 ?
          <List sx={{px: 0}}>
            {advCommits.map((commit: Commit, i) => (
              <ListItem key={i} sx={{px: 0}}>
                <CommitCard
                  commit={commit}
                  makeReview={() => makeReview(commit)}
                />
              </ListItem>
            ))}
          </List> : null
        }

        {advReviews.length > 0 ?
          <Grid container direction="row" spacing={2} sx={{mt: 3}}>
            <Grid item xs={12}>
              <Typography variant='h4'>
                Reviews on this advert
              </Typography>
            </Grid>
            {advReviews.map((review: Review, i) => (
              <Grid item xs={6} key={i} >
                <ReviewCard review={review} api={api} />
              </Grid>
            ))}
          </Grid> : null
        }

        {vndReviews.length > 0 ?
          <>
            <Typography variant='h4'>
              Past reviews for {vendor}
            </Typography>
            <List sx={{px: 0}}>
              {vndReviews.map((review: Review, i) => (
                <ListItem key={i} sx={{px: 0}}>
                  <ReviewCard review={review} api={api} />
                </ListItem>
              ))}
            </List>
          </> : null
        }

        {advert.vendor.ship === myShip ? 
          <>
            <Backdrop open={openBackdrop} />
            <SpeedDial
              ariaLabel="Edit Advert SpeedDial"
              sx={{ position: 'fixed', bottom: theme.spacing(3), right: theme.spacing(4) }}
              icon={<ExpandLessIcon />}
              onClose={() => setOpenBackdrop(false)}
              onOpen={() => setOpenBackdrop(true)}
              open={openBackdrop}
            >
              <SpeedDialAction
                key="edit"
                icon={<EditIcon />}
                tooltipTitle="Edit"
                tooltipOpen
                onClick={() => {setOpenNewAdvertDialog(true); setOpenBackdrop(false)}}
              />
              <SpeedDialAction
                key="delete"
                icon={<DeleteIcon />}
                tooltipTitle="Delete"
                tooltipOpen
                onClick={() => {setOpenDeleteConfirmation(true); setOpenBackdrop(false)}}
              />
              
            </SpeedDial>

            <AdvertEditor
              oldAdvert={advert}
              open={openNewAdvertDialog} handleCloseDialog={() => setOpenNewAdvertDialog(false)}
              api={api}
            /> 
          </> : null
        }

        <ReviewEditor
          commit={reviewCommit}
          open={openNewReviewDialog}
          handleCloseDialog={() => setOpenNewReviewDialog(false)}
          api={api}
        />

        <Dialog open={openDeleteConfirmation} onClose={() => setOpenDeleteConfirmation(false)}>
          <DialogContent>
            <DialogContentText>
              Are you sure you want to delete this advert?
              This is an irreversible action.
            </DialogContentText>
            <DialogActions>
              <Button variant="contained" onClick={() => { deleteAd(advert.hash); setOpenDeleteConfirmation(false)}}>
                Yes, I'm sure! Delete ad.
              </Button>
              <Button variant="contained" onClick={() => setOpenDeleteConfirmation(false)}>
                Cancel
              </Button>
            </DialogActions>
          </DialogContent>
        </Dialog>

    </Box>
  )} else return (
    <CircularProgress color="inherit" sx={{margin: theme.spacing(16)}} />
  )
}
