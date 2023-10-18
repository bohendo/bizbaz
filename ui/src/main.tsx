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

const api = new Urbit('', '', window.desk);
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
        path: "/explore",
        element: <Explore />,
      },
      {
        path: "/profile/:ship",
        element: <Profile />,
      },
    ]
  },
], { basename: "/apps/bizbaz" });

createRoot(document.getElementById('app')!).render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>,
);