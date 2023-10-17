import React from "react";
import { Link, NavLink } from "react-router-dom";

let hashFragment = "";
let observer = null as any;
let asyncTimerId = null as any;
let scrollFunction = null as any;

function reset() {
  hashFragment = "";
  if (observer !== null) {
    observer.disconnect();
  }
  if (asyncTimerId !== null) {
    window.clearTimeout(asyncTimerId);
    asyncTimerId = null;
  }
}

function getElAndScroll() {
  const element = document.getElementById(hashFragment);
  if (element !== null) {
    scrollFunction(element);
    reset();
    return true;
  }
  return false;
}

function hashLinkScroll() {
  // Push onto callback queue so it runs after the DOM is updated
  window.setTimeout(() => {
    if (getElAndScroll() === false) {
      if (observer === null) {
        observer = new MutationObserver(getElAndScroll);
      }
      observer.observe(document, {
        attributes: true,
        childList: true,
        subtree: true,
      });
      // if the element doesn't show up in 10 seconds, stop checking
      asyncTimerId = window.setTimeout(() => {
        reset();
      }, 10000);
    }
  }, 0);
}

const genericHashLink = (props: any, As: any, ref: any) => {
  const { scroll, smooth, ...filteredProps } = props;
  function handleClick(e: any) {
    reset();
    if (props.onClick) props.onClick(e);
    if (typeof props.to === "string") {
      hashFragment = props.to
        .split("#")
        .slice(1)
        .join("#");
    } else if (
      typeof props.to === "object" &&
      typeof props.to.hash === "string"
    ) {
      hashFragment = props.to.hash.replace("#", "");
    }
    if (hashFragment !== "") {
      scrollFunction =
        scroll ||
        ((el: HTMLElement) =>
          smooth
            ? el.scrollIntoView({ behavior: "smooth" })
            : el.scrollIntoView());
      hashLinkScroll();
    }
  }
  return (
    <As ref={ref} {...filteredProps} onClick={handleClick}>
      {props.children}
    </As>
  );
};

export const HashLink = React.forwardRef((props, ref) => {
  return genericHashLink(props, Link, ref);
});
HashLink.displayName = "HashLink";

export const NavHashLink = React.forwardRef((props, ref) => {
  return genericHashLink(props, NavLink, ref);
});
NavHashLink.displayName = "NavHashLink";
