import React, { useContext, useEffect, useState, useCallback } from "react";
import { Outlet, useNavigate } from "react-router-dom";

import { BizbazContext } from "./BizbazContext"
import { TAdvert, TCommit, TIntent, TReview, TVote } from "./types";

// Components
import { NavBar } from "./components/Navbar";

// MUI 
import CssBaseline from "@mui/material/CssBaseline";
import Container from "@mui/material/Container";
import { ThemeProvider, styled } from "@mui/material/styles";
import { darkTheme, lightTheme } from "./styles";

const savedTheme = localStorage.getItem("theme") || "";

export const App = ({ api }: { api: any }) => {
  const [theme, setTheme] = useState(savedTheme === "dark" || savedTheme === "" ? darkTheme : lightTheme);
  const [adverts, setAdverts] = useState([] as Array<TAdvert>);
  const [votes, setVotes] = useState([] as Array<TVote>);
  const [intents, setIntents] = useState([] as Array<TIntent>);
  const [commits, setCommits] = useState([] as Array<TCommit>);
  const [reviews, setReviews] = useState([] as Array<TReview>);

  const navigate = useNavigate();

  useEffect(() => {
    (async () => {
      console.log(`Subscribing to all bizbaz paths`)
      api.subscribe( { app: "bizbaz", path: '/json/adverts', event: updateAdverts } )
      api.subscribe( { app: "bizbaz", path: '/json/votes', event: updateVotes } )
      api.subscribe( { app: "bizbaz", path: '/json/reviews', event: updateReviews } )
    })()
  }, []);

  const updateAdverts = ( upd: any) => {
    console.log(`Got ${Object.keys(upd)} advert update:`, upd)
    if (upd.gather) {
      setAdverts(upd.gather.adverts || [] as Array<TAdvert>)
    } else if (upd.create) {
      console.log(`Adding newly created advert`)
      setAdverts((oldAdverts: Array<TAdvert>) => [upd.create.advert, ...oldAdverts])
    } else if (upd.update) {
      const newAdvert = upd.update.new
      const oldHash = upd.update.old
      const oldAdvert = adverts.findIndex(a => a.hash === newAdvert.hash)
      if (oldAdvert === -1) {
        setAdverts((oldAdverts: Array<TAdvert>) => [upd.update.new, ...oldAdverts])
      } else {
        setAdverts((oldAdverts: Array<TAdvert>) =>
          [...oldAdverts!.slice(0, oldAdvert), upd.update.new, ...oldAdverts!.slice(oldAdvert + 1)]
        )
      }
      navigate(`/advert/${newAdvert.hash}`)
    } else if (upd.delete) {
      setAdverts((oldAdverts: Array<TAdvert>) =>
        oldAdverts.filter((ad: TAdvert) => upd.delete.advert !== ad.hash)
      )
      navigate(`/`)
    } else {
      console.log(`Unknown vote update`)
    }
  }

  const updateVotes = (upd: any) => {
    console.log(`Got %${Object.keys(upd)} vote update:`, upd)
    if (upd.gather) {
      setVotes(upd.gather.votes)
    } else if (upd.vote) {
      const newVote = upd.vote
      setVotes((oldVotes: TVote[]): TVote[] => {
        if (oldVotes.find(v => v.hash === newVote.hash) !== undefined) {
          console.log(`Ignoring duplicate vote w hash ${newVote.hash}`)
          return oldVotes
        }
        const recast = oldVotes!.findIndex(v =>
          v.body.advert === newVote.body.advert && v.body.voter === newVote.body.voter
        )
        if (recast === -1) {
          if (newVote.body.choice === "un") {
            console.log(`Ignoring new unvote`)
            return oldVotes
          }
          console.log(`Adding new vote`)
          return [...oldVotes!, newVote]
        } else {
          console.log(`This is a recast vote, updating the previous vote to ${newVote.body.choice}`)
          if (newVote.body.choice === "un") {
            return [...oldVotes!.slice(0, recast), ...oldVotes!.slice(recast + 1)]
          } else {
            return [...oldVotes!.slice(0, recast), newVote, ...oldVotes!.slice(recast + 1)]
          }
        }
      })
    } else {
      console.log(`Unknown vote update`)
    }
  }

  const updateReviews = (upd: any) => {
    console.log(`Got %${Object.keys(upd)} reviews update:`, upd)
    if (!!upd.gather) {
      setIntents(upd.gather.intents)
      setCommits(upd.gather.commits)
      setReviews(upd.gather.reviews)
    } else if (!!upd.intent) {
      setIntents((oldIntents) => [upd.intent, ...oldIntents])
    } else if (!!upd.commit) {
      setCommits((oldCommits) => [upd.commit, ...oldCommits])
    } else if (!!upd.review) {
      setReviews((oldReviews) => [upd.review, ...oldReviews])
    } else if (!!upd.update) {
      setReviews((oldReviews) => {
        const oldRev = upd.oldRev
        const newRev = upd.newRev
        const oldIdx = oldReviews.findIndex(r => r.hash == oldRev)
        if (oldIdx === -1) {
          console.log(`Uhh, no existing review matches this update.. Adding it as if it were a new review`)
          return [newRev, ...oldReviews]
        }
        return [
          ...oldReviews.slice(0, oldIdx),
          newRev,
          ...oldReviews.slice(oldIdx + 1)
        ]
      })
    } else {
      console.log("Unknown review updates")
    }
  }

  const toggleTheme = () => {
    if (theme.palette.mode === "dark") {
      localStorage.setItem("theme", "light");
      setTheme(lightTheme);
    } else {
      localStorage.setItem("theme", "dark");
      setTheme(darkTheme);
    }
  };

  const MainContainer = styled(Container)(({ theme }) => ({
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    height: "100%",
    backgroundColor: theme.palette.background.default,
}));


  console.log(theme.palette)
  return (
    <BizbazContext.Provider value={{
      adverts: adverts,
      votes: votes!,
      intents: intents,
      commits: commits,
      reviews: reviews,
    }}>
      <ThemeProvider theme={theme}>
          <NavBar api={api} toggleTheme={toggleTheme} />
          <MainContainer id="main">
            <Outlet />
          </MainContainer>
      </ThemeProvider>
    </BizbazContext.Provider>
  );
}
