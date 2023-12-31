import React from 'react';
import { createRoot } from 'react-dom/client';
import {
  createBrowserRouter,
  RouterProvider,
} from "react-router-dom";
import './index.css';

// Urbit
import Urbit from "@urbit/http-api";

import { App } from './app';
import { Advert } from './pages/Advert';
import { Explore } from "./pages/Explore";
import { Profile } from "./pages/Profile";

const api = new Urbit('', '', 'bizbaz');
api.ship = window.ship;

const router = createBrowserRouter([
  {
    path: "/",
    element: <App api={api} />,
    children: [
      {
        path: "/",
        element: <Explore />,
      },
      {
        path: "/advert/:hash",
        element: <Advert api={api} />,
      },
      {
        path: "/profile/:ship",
        element: <Profile api={api} />,
      },
    ]
  },
], { basename: "/apps/bizbaz/" });

createRoot(document.getElementById('app')!).render(
  <RouterProvider router={router} />
);
