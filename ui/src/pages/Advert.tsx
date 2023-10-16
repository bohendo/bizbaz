import React, { useContext, useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';

// MUI
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import CircularProgress from '@mui/material/CircularProgress';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import Fab from '@mui/material/Fab'
import Paper from "@mui/material/Paper";
import Typography from '@mui/material/Typography';
import { useTheme } from "@mui/material/styles"

import { BizbazContext } from "../BizbazContext"

import { TAdvert, TCommit, TIntent, TReview, TVote } from "../types";

// Icons
import EditIcon from '@mui/icons-material/Edit';

// Components
import { Votes } from '../components/Votes';
import { IntentCard } from '../components/IntentCard';
import { CommitCard } from "../components/CommitCard";
import { ReviewCard } from "../components/ReviewCard";
import { NewAdvert } from "../components/NewAdvert";
import { NewReview } from "../components/NewReview";
import { ShipLink } from "../components/ShipLink";

export const Advert = ({ api }: { api: any }) => {
  const bizbaz = useContext(BizbazContext);
  const theme = useTheme();
  const { hash } = useParams();
  const navigate = useNavigate();

  const [reviewCommit, setReviewCommit] = useState<TCommit | undefined>(undefined);
  const [openNewAdvertDialog, setOpenNewAdvertDialog] = useState(false);
  const [openNewReviewDialog, setOpenNewReviewDialog] = useState(false);

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
    .filter(r => !advReviews.some(ar => ar.hash === r.hash))

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

  const intent = () => {
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
    return (
      <Box sx={{width: "100%", mt: theme.spacing(10)}}>
        <Paper variant="outlined" sx={{ p: 8, m: 8 }}>
          <Typography variant="h2">
            {advert.body.title}
          </Typography>
          <Typography variant="caption">
            Posted by: <ShipLink ship={advert.vendor.ship} />
          </Typography>
          <Typography variant="h5">
            Tags: {advert.body.tags?.join(", ")}
          </Typography>
          <Typography variant="body1">
            Description: {advert.body.description}
          </Typography>

          <Votes votes={votes.filter((v: TVote) => v.body.advert === hash)} vote={vote} />

          {(ourShip !== advert.vendor.ship) ? (
            <Box sx={{ display: 'flex', justifyContent: 'center', marginBottom: 2 }}>
              <Button
                variant="contained"
                onClick={intent}
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
            <Fab color='primary' sx={{
              position: 'fixed',
              right: theme.spacing(4),
              bottom: theme.spacing(3)
            }} onClick={() => setOpenNewAdvertDialog(true)}>
              <EditIcon />
            </Fab>

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

    </Box>
  )} else return (
    <CircularProgress color="inherit" sx={{margin: theme.spacing(16)}} />
  )
}
