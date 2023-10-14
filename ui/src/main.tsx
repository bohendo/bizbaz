import React from 'react';
import ReactDOM from 'react-dom';
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
        path: "/advert/:hash",
        element: <Advert api={api} />,
      },
      {
        path: "/explore",
        element: <Explore api={api} />,
      },
      {
        path: "/profile",
        element: <Profile api={api} />,
      },
    ]
  },
], { basename: "/apps/bizbaz" });

ReactDOM.render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>,
  document.getElementById('app')
);
