import React, { useContext, useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';

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
import Typography from '@mui/material/Typography';
import { useTheme } from "@mui/material/styles"

import { BizbazContext } from "../BizbazContext"

import { TAdvert, TCommit, TIntent, TReview, TVote } from "../types";

// Icons
import DeleteIcon from '@mui/icons-material/Delete';
import EditIcon from '@mui/icons-material/Edit';
import ExpandLessIcon from '@mui/icons-material/ExpandLess';

// Components
import { Votes } from '../components/Votes';
import { IntentCard } from '../components/IntentCard';
import { CommitCard } from "../components/CommitCard";
import { ReviewCard } from "../components/ReviewCard";
import { NewAdvert } from "../components/NewAdvert";
import { NewReview } from "../components/NewReview";
import { ShipLink } from "../components/ShipLink";
import { Markdown } from "../components/Markdown";

export const Advert = ({ api }: { api: any }) => {
  const bizbaz = useContext(BizbazContext);
  const theme = useTheme();
  const { hash } = useParams();
  const navigate = useNavigate();

  const [reviewCommit, setReviewCommit] = useState<TCommit | undefined>(undefined);
  const [openNewAdvertDialog, setOpenNewAdvertDialog] = useState(false);
  const [openNewReviewDialog, setOpenNewReviewDialog] = useState(false);
  const [openBackdrop, setOpenBackdrop] = useState(false);
  const [openDeleteConfirmation, setOpenDeleteConfirmation] = useState(false);
  const [imgError, setImgError] = useState(false);

  const ourShip = `~${window.ship}`

  const { adverts, votes, intents, commits, reviews } = bizbaz;

  // Calculate some dynamic values from our bizbaz state
  const advert = adverts.find(a => a.hash === hash);
  const vendor = advert?.vendor?.ship;
  const advIntents = intents.filter(i => i.body.advert === hash);
  const advCommits = commits.filter(c => c.intent.advert === hash);
  const advReviews = reviews.filter(r => r.commit.intent.advert === hash);
  const vndReviews = reviews
    .filter(r => r.commit.vendor.ship === vendor)
    .filter(r => !advReviews.some(ar => ar.hash === r.hash));
  
  const updateAdvert = ( upd: any) => {
    if (upd.update) {
      navigate(`advert/${upd.update.update.new.hash}`)
    }
  }

  useEffect(() => {
    async function init() {
      api.subscribe( { app: "bizbaz", path: '/json/adverts', event: updateAdvert } )
    }
    init();
  }, []);

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

  const doCommit = (intent: TIntent) => {
      if (!intent) {
          console.log(`No intent exists to commit to`)
          return
      }
      console.log(`Committing to intent ${intent}`)
      api.poke({
        app: 'bizbaz',
        mark: 'review-action',
        json: { 
          'commit': { intent }
        }
      })
  }

  const makeReview = (commit: TCommit) => {
    setReviewCommit(commit)
    setOpenNewReviewDialog(true)
  }

  if (advert === undefined) {
    // TODO: create error 404 not found page
    return <div> Advert does not exist </div>
  } else if (advert.body) {
    console.log(advIntents)
    return (
      <Box sx={{width: "100%", mt: theme.spacing(10)}}>
        <Paper variant="outlined" sx={{ p: 8, m: 8 }}>
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
                <Votes votes={votes.filter((v: TVote) => v.body.advert === hash)}
                  vote={vote} disabled={ourShip === advert.vendor.ship} />
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

          {(ourShip !== advert.vendor.ship) ? (
            <Box sx={{ display: 'flex', justifyContent: 'center', marginTop: 8 }}>
              <Button
                variant="contained"
                onClick={doIntent}
                disabled={!!advIntents.find(i => i.client.ship === ourShip)}
              >
                Express Intent
              </Button>
            </Box>
          ) : null}
        </Paper>

        {advIntents.length > 0 ? 
          <List sx={{px: 0}}>
            {advIntents.map((intent: TIntent, i) => (
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
            {advCommits.map((commit: TCommit, i) => (
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
          <List sx={{px: 0}}>
            {advReviews.map((review: TReview, i) => (
              <ListItem key={i} sx={{px: 0}}>
                <ReviewCard review={review} />
              </ListItem>
            ))}
          </List> : null
        }

        {vndReviews.length > 0 ?
          <List sx={{px: 0}}>
            {vndReviews.map((review: TReview, i) => (
              <ListItem key={i} sx={{px: 0}}>
                <ReviewCard review={review} />
              </ListItem>
            ))}
          </List> : null
        }

        {advert.vendor.ship === ourShip ? 
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

            <NewAdvert
              editAdvert={{
                hash: advert.hash,
                body: {
                  title: advert.body.title,
                  tags: advert.body.tags,
                  description: advert.body.description,
                  cover: advert.body.cover,
                  when: Date.now()
                }
              }}
              edit={true}
              open={openNewAdvertDialog} handleCloseDialog={() => setOpenNewAdvertDialog(false)}
              api={api}
            /> 
          </> : null
        }

        <NewReview
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
