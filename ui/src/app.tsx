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
  const myShip = `~${window.ship}`

  useEffect(() => {
    (async () => {
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
    console.log(`Got ${Object.keys(upd)} vote update:`, upd)
    if (upd.gather) {
      setVotes(upd.gather.votes)
    } else if (upd.vote) {
      const newVote = upd.vote
      setVotes((oldVotes: TVote[]): TVote[] => {
        if (oldVotes.find(v => v.hash === newVote.hash) !== undefined) {
          return oldVotes
        }
        const recast = oldVotes!.findIndex(v =>
          v.body.advert === newVote.body.advert && v.body.voter === newVote.body.voter
        )
        if (recast === -1) {
          if (newVote.body.choice === "un") {
            return oldVotes
          }
          return [...oldVotes!, newVote]
        } else {
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
    console.log(`Got ${Object.keys(upd)} review update:`, upd)
    if (!!upd.gather) {
      setIntents(upd.gather.intents.filter(
        (i: TIntent) => i.client.ship === myShip || i.body.vendor.ship === myShip
      ));
      setCommits(upd.gather.commits)
      setReviews(upd.gather.reviews)
    } else if (!!upd.intent) {
      let newIntent = upd.intent as TIntent;
      if (newIntent.client.ship === myShip || newIntent.body.vendor.ship === myShip) {
        setIntents((oldIntents) => [newIntent, ...oldIntents])
      }
    } else if (!!upd.commit) {
      setCommits((oldCommits) => [upd.commit, ...oldCommits])
      setIntents((oldIntents) => {
        if (!oldIntents) return []
        let oldIndex = oldIntents!.findIndex(i => i.hash === upd.commit.body.intent)
        if (oldIndex === -1) {
          return oldIntents
        }
        return [...oldIntents!.slice(0, oldIndex), ...oldIntents!.slice(oldIndex + 1)]
      });
    } else if (!!upd.review) {
      setReviews((oldReviews) => [upd.review, ...oldReviews])
      setCommits((oldCommits) => {
        if (!oldCommits) return []
        let oldIndex = oldCommits!.findIndex(i => i.hash === upd.review.commit.hash)
        if (oldIndex === -1) {
          return oldCommits
        }
        return [...oldCommits!.slice(0, oldIndex), ...oldCommits!.slice(oldIndex + 1)]
      });
    } else if (!!upd.update) {
      setReviews((oldReviews) => {
        const oldRev = upd.update.old;
        const newRev = upd.update.new;
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
    minWidth: '100vh',
}));

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
