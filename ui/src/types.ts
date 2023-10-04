export type TAdvertValidation = {
    hasError: boolean;
    errorMsgs: {
        coverError: string;
        descriptionError: string;
        tagsError: string;
        titleError: string;
    }
}

export type TNewAdvert = {
    hash?: string;
    cover: string;
    description: string;
    tags: Array<string>;
    title: string;
}

export type TAdvert = {
    hash: string;
    cover: string;
    description: string;
    tags: Array<string>;
    title: string;
    when: number;
    who: string;
}
