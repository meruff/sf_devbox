export default class LeaderboardProfileHelper {
    getTitleString(title, company) {
        let titleString = "";

        if (title) {
            titleString += title;
        }

        if (company) {
            titleString += ((title) ? "<br/>" : "") + company;
        }

        return titleString;
    }

    getProfileAlt(name) {
        return name.split(" ")[0] + "'s profile photo";
    }
}